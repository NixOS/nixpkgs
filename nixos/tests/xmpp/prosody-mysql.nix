let
  cert =
    pkgs:
    pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
      openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 365 \
        -subj '/C=GB/CN=example.com' -addext "subjectAltName = DNS:example.com,DNS:uploads.example.com,DNS:conference.example.com"
      mkdir -p $out
      cp key.pem cert.pem $out
    '';
  # Creates and set password for the 2 xmpp test users.
  #
  # Doing that in a bash script instead of doing that in the test
  # script allow us to easily provision the users when running that
  # test interactively.
  createUsers =
    pkgs:
    pkgs.writeShellScriptBin "create-prosody-users" ''
      set -e
      prosodyctl register cthon98 example.com nothunter2
      prosodyctl register azurediamond example.com hunter2
    '';
  # Deletes the test users.
  delUsers =
    pkgs:
    pkgs.writeShellScriptBin "delete-prosody-users" ''
      set -e
      prosodyctl deluser cthon98@example.com
      prosodyctl deluser azurediamond@example.com
    '';
in
import ../make-test-python.nix {
  name = "prosody-mysql";
  nodes = {
    client =
      {
        nodes,
        pkgs,
        config,
        ...
      }:
      {
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} example.com
          ${nodes.server.networking.primaryIPAddress} conference.example.com
          ${nodes.server.networking.primaryIPAddress} uploads.example.com
        '';
        environment.systemPackages = [
          (pkgs.callPackage ./xmpp-sendmessage.nix {
            connectTo = nodes.server.networking.primaryIPAddress;
          })
        ];
      };

    server =
      { nodes, pkgs, ... }:
      {
        nixpkgs.overlays = [
          (self: super: {
            prosody = super.prosody.override {
              withExtraLuaPackages = p: [ p.luadbi-mysql ];
            };
          })
        ];
        security.pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} example.com
          ${nodes.server.networking.primaryIPAddress} conference.example.com
          ${nodes.server.networking.primaryIPAddress} uploads.example.com
        '';
        networking.firewall.enable = false;
        environment.systemPackages = [
          (createUsers pkgs)
          (delUsers pkgs)
        ];
        services.prosody = {
          enable = true;
          ssl.cert = "${cert pkgs}/cert.pem";
          ssl.key = "${cert pkgs}/key.pem";
          virtualHosts.example = {
            domain = "example.com";
            enabled = true;
            ssl.cert = "${cert pkgs}/cert.pem";
            ssl.key = "${cert pkgs}/key.pem";
          };
          muc = [
            {
              domain = "conference.example.com";
            }
          ];
          httpFileShare = {
            domain = "uploads.example.com";
          };
          extraConfig = ''
            storage = "sql"
            sql = {
              driver = "MySQL";
              database = "prosody";
              host = "mysql";
              port = 3306;
              username = "prosody";
              password = "password123";
            };
          '';
        };
      };
    mysql =
      { config, pkgs, ... }:
      {
        networking.firewall.enable = false;
        services.mysql = {
          enable = true;
          initialScript = pkgs.writeText "mysql_init.sql" ''
            CREATE DATABASE prosody;
            CREATE USER 'prosody'@'server' IDENTIFIED BY 'password123';
            GRANT ALL PRIVILEGES ON prosody.* TO 'prosody'@'server';
            FLUSH PRIVILEGES;
          '';
          package = pkgs.mariadb;
        };
      };
  };

  testScript = _: ''
    # Check with mysql storage
    start_all()
    mysql.wait_for_unit("mysql.service")
    server.wait_for_unit("prosody.service")
    server.succeed('prosodyctl status | grep "Prosody is running"')

    server.succeed("create-prosody-users")
    client.succeed("send-message")
    server.succeed("delete-prosody-users")
  '';
}
