# A provider of one contract type can be a consumer of another contract type.
#
# - `webapp` requests a database connection with the `databaseConnection` contract.
# - `pgProvider` fulfills `databaseConnection` requests,
#   and requests a credential file with the `fileSecrets` contract.
#   The connection string contains the path of the credential file.
# - `hardcoded-secret` fulfills `fileSecrets` requests.
#
# The module system evaluates the chain lazily, thus the order of the modules has no effect.
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  name = "contracts-chaining";

  nodes.machine =
    { config, options, ... }:
    let
      inherit (config.contractTypes) databaseConnection;
      credential = config.contracts.fileSecrets.results.pgProvider.credential;
    in
    {
      # The consumer `webapp`.
      options.services.webapp.db = mkOption {
        description = "Database connection of `webapp`.";
        default = { };
        type = databaseConnection.mkContract {
          request.dbName.default = "webappdb";
        };
      };

      # The provider `pgProvider`.
      options.services.pgProvider.databaseConnection = mkOption {
        description = "Database connections that `pgProvider` fulfills.";
        type = databaseConnection.mkProviderType {
          fulfill = request: {
            connectionString = "postgresql:///${request.dbName}?password_file=${credential.path}";
          };
        };
      };

      config = {
        # The database connection contract type, for this test only.
        contractTypes.databaseConnection = {
          meta = {
            description = "A consumer requests a database, and a provider gives a connection string.";
            maintainers = [ lib.maintainers.kiara ];
          };
          interface = {
            options = {
              request = mkOption {
                description = "Request of the database connection contract.";
                type = types.submodule {
                  options.dbName = mkOption {
                    description = "Name of the database.";
                    type = types.str;
                  };
                };
              };
              response = mkOption {
                description = "Response of the database connection contract.";
                type = types.submodule {
                  options.connectionString = mkOption {
                    description = "Connection string of the database.";
                    type = types.str;
                  };
                };
              };
            };
          };
        };

        contracts.databaseConnection.want.webapp.db = {
          inherit (config.services.webapp.db) request;
        };
        services.webapp.db.response = config.contracts.databaseConnection.results.webapp.db;
        environment.etc."webapp/connection".text = config.services.webapp.db.response.connectionString;

        services.pgProvider.databaseConnection =
          config.contracts.databaseConnection.providerRequests.pgProvider;
        contracts.databaseConnection.providers.pgProvider.module = options.services.pgProvider;
        contracts.databaseConnection.defaultProvider =
          config.contracts.databaseConnection.providers.pgProvider;

        # `pgProvider` is also a consumer of a file secret.
        contracts.fileSecrets.want.pgProvider.credential.request = {
          owner = "root";
          group = "root";
        };

        contracts.fileSecrets.defaultProvider = config.contracts.fileSecrets.providers.hardcoded-secret;
        testing.hardcoded-secret.fileSecrets.pgProvider.credential.providerOptions.content =
          "s3cret-db-password";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    connection = machine.succeed("cat /etc/webapp/connection").strip()
    expected = "postgresql:///webappdb?password_file=/run/hardcodedsecrets/pgProvider/credential"
    assert connection == expected, f"Connection string should be '{expected}' but got '{connection}'"

    password_file = connection.split("password_file=", 1)[1]
    content = machine.succeed(f"cat {password_file}").strip()
    assert content == "s3cret-db-password", f"Credential should be 's3cret-db-password' but got '{content}'"
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}
