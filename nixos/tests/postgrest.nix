import ./make-test-python.nix ({pkgs, ...}: {
  name = "postgrest";
  meta = with pkgs.lib.maintainers; {
    maintainers = [matthewcroughan evanpiro];
  };

  nodes = {
    client = {
      config,
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [curl];
    };
    postgresql = {
      config,
      pkgs,
      lib,
      ...
    }: {
      networking.firewall.allowedTCPPorts = [config.services.postgresql.port];
      services.postgresql = {
        enable = true;
        settings.listen_addresses = lib.mkForce "*";
        initialScript = pkgs.writeText "initial-postgrest.sql" ''
          CREATE ROLE anon nologin;
          CREATE TABLE books (title TEXT NOT NULL);
          INSERT INTO books VALUES ('Ulysses');
          grant usage on schema public to anon;
          grant select on books to anon;
        '';
       authentication = ''
          host all all 192.168.1.0/24 trust
        '';
      };
    };
    postgrest = {
      config,
      pkgs,
      ...
    }: {
      networking.firewall.allowedTCPPorts = [config.services.postgrest.port];
      services.postgrest = {
        port = 8079;
        postgresUser = "postgres";
        postgresHost = "postgresql";
        anonRole = "anon";
        postgresDatabase = "postgres";
        enable = true;
        package = pkgs.haskellPackages.postgrest;
      };
    };
  };

  testScript = {nodes, ...}: let
    postgrestPort = toString nodes.postgrest.config.services.postgrest.port;
    postgresqlPort = toString nodes.postgresql.config.services.postgresql.port;
  in ''
    start_all()

    postgresql.wait_for_unit("multi-user.target")
    postgresql.wait_for_unit("postgresql.service")
    postgresql.wait_for_open_port(${postgresqlPort})

    postgrest.wait_for_unit("multi-user.target")
    postgrest.wait_for_unit("postgrest.service")
    postgresql.succeed("netstat -plnt >&2")
    postgrest.wait_for_open_port(${postgrestPort})

    client.succeed("curl --fail postgrest:${postgrestPort}/books >&2")
  '';
})
