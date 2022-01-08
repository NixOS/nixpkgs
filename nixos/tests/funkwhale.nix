import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "funkwhale";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hexa ];
  };

  machine = { ... }: {
    networking.extraHosts = ''
      127.0.0.1 funkwhale.local
    '';

    services.redis.servers.funkwhale = {
      enable = true;
      bind = "localhost";
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "funkwhale" ];
      ensureUsers = [ {
        name = "funkwhale";
        ensurePermissions = {
          "DATABASE funkwhale" = "ALL PRIVILEGES";
        };
      } ];
    };

    services.funkwhale = {
      enable = true;
      settings = {
        FUNKWHALE_HOSTNAME = "funkwhale.local";
        MUSIC_DIRECTORY_PATH = "/var/lib/funkwhale";
        DATABASE_URL = "postgres:////run/postgresql/funkwhale";
        CACHE_URL = "redis://localhost:6379/0";
      };
      superUserPasswordFile = pkgs.writeText "superuser-password-file" "insecure";
    };
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("funkwhale-beat")
      machine.wait_for_unit("funkwhale-worker")
      machine.wait_for_unit("funkwhale-server")

      machine.wait_for_open_port(5678)

      # TODO: this fails because we are accessing the API directly and
      # it expects to be reverse proxied and have the frontend
      # accessible.
      machine.succeed(
          "${pkgs.curl}/bin/curl --fail http://funkwhale.local"
      )

      machine.shutdown()
    '';
})
