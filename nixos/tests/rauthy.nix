import ./make-test-python.nix (
  {
    lib,
    ...
  }:
  {
    name = "rauthy";
    meta.maintainers = with lib.maintainers; [
      gepbird
    ];

    nodes.machine =
      {
        ...
      }:
      {
        services.rauthy = {
          enable = true;
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "rauthy" ];
          ensureUsers = [
            {
              name = "rauthy";
              ensureDBOwnership = true;
            }
          ];
        };
      };

    testScript = ''
      machine.wait_for_unit("rauthy.service")
      machine.succeed("sleep 5")
    '';
  }
)
