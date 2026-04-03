# Tests contract chaining: a provider that is also a consumer.
#
# Chain: webapp <-[databaseConnection]-- pgProvider <--[fileSecret]-- hardcoded-secret
#
# - `webapp` (consumer): requests a database connection via the
#   `databaseConnection` contract and reads `result.connectionString`.
# - `pgProvider` (provider + consumer): fulfills `databaseConnection`
#   requests, but itself consumes `fileSecrets` to get a credential file.
#   The connection string embeds the credential path from `fileSecrets`.
# - `hardcoded-secret` (provider): fulfills `fileSecrets` requests by
#   writing secret content to files with the requested permissions.
#
# Nix lazy evaluation resolves the chain automatically -- no explicit
# ordering is needed. The test verifies both the eval-time plumbing
# (assertions) and the runtime result (credential file exists with
# correct content).
{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;

  # Database connection contract, defined inline for the test.
  dbContractDef = {
    meta = {
      description = ''
        Contract for database connections where a consumer requests a named
        database and a provider returns a connection string.
      '';
      maintainers = [ ];
    };
    interface = {
      request.dbName = mkOption {
        description = "Name of the database to connect to.";
        type = types.str;
      };
      result.connectionString = mkOption {
        description = "Connection string for the database.";
        type = types.str;
      };
    };
  };

  dbContract = lib.evalOption (mkOption { type = lib.contract.templateType; }) dbContractDef;
in
{
  name = "contracts-chaining";

  containers.machine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (dbContract) mkContract;
      credentialPath = config.contracts.fileSecrets.results.pgProvider.credential.path;
      expectedConnectionString = "postgresql:///webappdb?password_file=${credentialPath}";
    in
    {
      imports = [
        # Provides the hardcoded-secret fileSecrets provider.
        ../../modules/testing/hardcoded-secret.nix
      ];

      # --- WEBAPP: consumer of databaseConnection ---

      options.services.webapp.db = mkOption {
        description = "Database connection for the webapp.";
        type = mkContract {
          request.dbName.default = "webappdb";
        };
      };

      # --- PGPROVIDER: provides databaseConnection, consumes fileSecrets ---

      options.services.pgProvider.databaseConnection = mkOption {
        description = "Database connection instances fulfilled by this provider.";
        default = config.contracts.databaseConnection.requests;
        type = dbContract.mkProviderType {
          fulfill =
            { dbName }:
            {
              connectionString = "postgresql:///${dbName}?password_file=${credentialPath}";
            };
        };
      };

      config = {
        contractTypes.databaseConnection = dbContractDef;

        # Consumer wiring: register want, read result.
        contracts.databaseConnection.want.webapp.db = config.services.webapp.db;
        services.webapp.db.result = config.contracts.databaseConnection.results.webapp.db;

        # Provider wiring: register provider.
        contracts.databaseConnection.providers.pgProvider = config.services.pgProvider.databaseConnection;

        # Chain: the database provider also consumes fileSecrets for credentials.
        contracts.fileSecrets.want.pgProvider.credential = {
          request = {
            owner = "root";
            group = "root";
          };
        };

        # Set up credential content for the hardcoded-secret provider.
        testing.hardcoded-secret.fileSecrets.pgProvider.credential.content = "s3cret-db-password";

        # Default providers.
        contracts.databaseConnection.defaultProviderName = "pgProvider";
        contracts.fileSecrets.defaultProviderName = "hardcoded-secret";

        # --- ASSERTIONS ---

        assertions = [
          {
            assertion = config.services.webapp.db.result.connectionString == expectedConnectionString;
            message = ''
              chaining: webapp should receive connection string
              '${expectedConnectionString}'
              but got '${config.services.webapp.db.result.connectionString}'
            '';
          }
        ];
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # The credential file from the fileSecrets chain should exist with the right content.
    content = machine.succeed("cat /run/hardcodedsecrets/credential").strip()
    assert content == "s3cret-db-password", \
        f"Expected credential content 's3cret-db-password', got '{content}'"
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}
