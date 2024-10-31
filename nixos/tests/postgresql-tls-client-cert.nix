{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
, package ? null
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;

  # Makes a test for a PostgreSQL package, given by name and looked up from `pkgs`.
  makeTestAttribute = name:
    {
      inherit name;
      value = makePostgresqlTlsClientCertTest pkgs."${name}";
    };

  makePostgresqlTlsClientCertTest = pkg:
    let
      runWithOpenSSL = file: cmd: pkgs.runCommand file
        {
          buildInputs = [ pkgs.openssl ];
        }
        cmd;
      caKey = runWithOpenSSL "ca.key" "openssl ecparam -name prime256v1 -genkey -noout -out $out";
      caCert = runWithOpenSSL
        "ca.crt"
        ''
          openssl req -new -x509 -sha256 -key ${caKey} -out $out -subj "/CN=test.example" -days 36500
        '';
      serverKey =
        runWithOpenSSL "server.key" "openssl ecparam -name prime256v1 -genkey -noout -out $out";
      serverKeyPath = "/var/lib/postgresql";
      serverCert =
        runWithOpenSSL "server.crt" ''
          openssl req -new -sha256 -key ${serverKey} -out server.csr -subj "/CN=db.test.example"
          openssl x509 -req -in server.csr -CA ${caCert} -CAkey ${caKey} \
            -CAcreateserial -out $out -days 36500 -sha256
        '';
      clientKey =
        runWithOpenSSL "client.key" "openssl ecparam -name prime256v1 -genkey -noout -out $out";
      clientCert =
        runWithOpenSSL "client.crt" ''
          openssl req -new -sha256 -key ${clientKey} -out client.csr -subj "/CN=test"
          openssl x509 -req -in client.csr -CA ${caCert} -CAkey ${caKey} \
            -CAcreateserial -out $out -days 36500 -sha256
        '';
      clientKeyPath = "/root";

    in
    makeTest {
      name = "postgresql-tls-client-cert-${pkg.name}";
      meta.maintainers = with lib.maintainers; [ erictapen ];

      nodes.server = { ... }: {
        system.activationScripts = {
          keyPlacement.text = ''
            mkdir -p '${serverKeyPath}'
            cp '${serverKey}' '${serverKeyPath}/server.key'
            chown postgres:postgres '${serverKeyPath}/server.key'
            chmod 600 '${serverKeyPath}/server.key'
          '';
        };
        services.postgresql = {
          package = pkg;
          enable = true;
          enableTCPIP = true;
          ensureUsers = [
            {
              name = "test";
              ensureDBOwnership = true;
            }
          ];
          ensureDatabases = [ "test" ];
          settings = {
            ssl = "on";
            ssl_ca_file = toString caCert;
            ssl_cert_file = toString serverCert;
            ssl_key_file = "${serverKeyPath}/server.key";
          };
          authentication = ''
            hostssl test test ::/0 cert clientcert=verify-full
          '';
        };
        networking = {
          interfaces.eth1 = {
            ipv6.addresses = [
              { address = "fc00::1"; prefixLength = 120; }
            ];
          };
          firewall.allowedTCPPorts = [ 5432 ];
        };
      };

      nodes.client = { ... }: {
        system.activationScripts = {
          keyPlacement.text = ''
            mkdir -p '${clientKeyPath}'
            cp '${clientKey}' '${clientKeyPath}/client.key'
            chown root:root '${clientKeyPath}/client.key'
            chmod 600 '${clientKeyPath}/client.key'
          '';
        };
        environment = {
          variables = {
            PGHOST = "db.test.example";
            PGPORT = "5432";
            PGDATABASE = "test";
            PGUSER = "test";
            PGSSLMODE = "verify-full";
            PGSSLCERT = clientCert;
            PGSSLKEY = "${clientKeyPath}/client.key";
            PGSSLROOTCERT = caCert;
          };
          systemPackages = [ pkg ];
        };
        networking = {
          interfaces.eth1 = {
            ipv6.addresses = [
              { address = "fc00::2"; prefixLength = 120; }
            ];
          };
          hosts = { "fc00::1" = [ "db.test.example" ]; };
        };
      };

      testScript = ''
        server.wait_for_unit("multi-user.target")
        client.wait_for_unit("multi-user.target")
        client.succeed("psql -c \"SELECT 1;\"")
      '';
    };

in
if package == null then
# all-tests.nix: Maps the generic function over all attributes of PostgreSQL packages
  builtins.listToAttrs (map makeTestAttribute (builtins.attrNames (import ../../pkgs/servers/sql/postgresql pkgs)))
else
# Called directly from <package>.tests
  makePostgresqlTlsClientCertTest package
