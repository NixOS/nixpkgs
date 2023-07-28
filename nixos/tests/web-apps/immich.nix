import ../make-test-python.nix ({pkgs, ...}: let
  typesenseApiKeyFile = pkgs.writeText "typesense-api-key" "12318551487654187654";
in {
  name = "immich-nixos";
  # TODO second machine test distributed setup
  nodes.machine = {
    self,
    pkgs,
    ...
  }: {
    # These tests need a little more juice
    virtualisation.cores = 2;
    virtualisation.memorySize = 2048;

    services.immich = {
      enable = true;
      server.typesense.apiKeyFile = typesenseApiKeyFile;
    };

    services.typesense = {
      enable = true;
      # In a real setup you should generate an api key for immich
      # and not use the admin key!
      apiKeyFile = typesenseApiKeyFile;
      settings.server.api-address = "127.0.0.1";
    };

    services.postgresql = {
      enable = true;
      identMap = ''
        # ArbitraryMapName systemUser DBUser
        superuser_map      root      postgres
        superuser_map      postgres  postgres
        # Let other names login as themselves
        superuser_map      /^(.*)$   \1
      '';
      authentication = pkgs.lib.mkOverride 10 ''
        local sameuser all peer map=superuser_map
      '';

      ensureDatabases = [ "immich" ];
      ensureUsers = [
        {
          name = "immich";
          ensurePermissions = {
            "DATABASE immich" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };

  testScript = ''
    start_all()

    # wait for our service to start
    machine.wait_for_unit("immich-server.service")
    # machine.wait_for_open_port(${toString 1234})
    # machine.succeed("curl --fail http://localhost:${toString 1234}/")

    machine.wait_for_open_port(${toString 3000})
    machine.wait_for_open_port(${toString 3001})
    machine.wait_for_open_port(${toString 3002})
    machine.wait_for_open_port(${toString 3003})
    # TODO microservices
    # TODO machine learning
    # TODO web
  '';
})
