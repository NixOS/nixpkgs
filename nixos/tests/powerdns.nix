# This test runs PowerDNS authoritative server with the
# generic MySQL backend (gmysql) to connect to a
# MariaDB server using UNIX sockets authentication.

import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "powerdns";

    nodes.server =
      { ... }:
      {
        services.powerdns.enable = true;
        services.powerdns.extraConfig = ''
          launch=gmysql
          gmysql-user=pdns
          zone-cache-refresh-interval=0
        '';

        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          ensureDatabases = [ "powerdns" ];
          ensureUsers = lib.singleton {
            name = "pdns";
            ensurePermissions = {
              "powerdns.*" = "ALL PRIVILEGES";
            };
          };
        };

        environment.systemPackages = with pkgs; [
          dnsutils
          powerdns
          mariadb
        ];
      };

    testScript = ''
      with subtest("PowerDNS database exists"):
          server.wait_for_unit("mysql")
          server.succeed("echo 'SHOW DATABASES;' | sudo -u pdns mysql -u pdns >&2")

      with subtest("Loading the MySQL schema works"):
          server.succeed(
              "sudo -u pdns mysql -u pdns -D powerdns <"
              "${pkgs.powerdns}/share/doc/pdns/schema.mysql.sql"
          )

      with subtest("PowerDNS server starts"):
          server.wait_for_unit("pdns")
          server.succeed("dig version.bind txt chaos @127.0.0.1 >&2")

      with subtest("Adding an example zone works"):
          # Extract configuration file needed by pdnsutil
          pdnsutil = "sudo -u pdns pdnsutil "
          server.succeed(f"{pdnsutil} create-zone example.com ns1.example.com")
          server.succeed(f"{pdnsutil} add-record  example.com ns1 A 192.168.1.2")

      with subtest("Querying the example zone works"):
          reply = server.succeed("dig +noall +answer ns1.example.com @127.0.0.1")
          assert (
              "192.168.1.2" in reply
          ), f""""
          The reply does not contain the expected IP address:
            Expected:
              ns1.example.com.        3600    IN      A       192.168.1.2
            Reply:
              {reply}"""
    '';
  }
)
