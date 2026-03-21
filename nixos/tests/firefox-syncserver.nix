let
  makeFirefoxSyncserverTest =
    name:
    {
      backend ? name,
    }:
    import ./make-test-python.nix (
      { lib, pkgs, ... }:
      {
        name = "firefox-syncserver-${name}";

        nodes.machine =
          { pkgs, ... }:
          lib.mkMerge [
            {
              mysql = {
                services.mysql = {
                  enable = true;
                  package = pkgs.mariadb;
                };
              };
              postgresql = { };
            }
            .${backend}

            {
              services.firefox-syncserver = {
                enable = true;
                database.type = backend;
                secrets = pkgs.writeText "sync-secrets" ''
                  SYNC_MASTER_SECRET=a-]test-secret-that-is-not-real
                '';
                singleNode = {
                  enable = true;
                  hostname = "firefox-syncserver.local";
                  capacity = 1;
                };
              };
            }
          ];

        testScript = ''
          machine.wait_for_unit("multi-user.target")
          machine.wait_until_succeeds("systemctl is-active firefox-syncserver.service", timeout=120)
          machine.wait_for_open_port(5000)
          machine.wait_until_succeeds("curl --fail http://127.0.0.1:5000")
        '';
      }
    );
in
builtins.mapAttrs (k: v: makeFirefoxSyncserverTest k v) {
  mysql = { };
  postgresql = { };
}
