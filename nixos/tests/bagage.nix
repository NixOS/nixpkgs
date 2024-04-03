import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "bagage";

    meta.maintainers = with lib.maintainers; [ bhankas ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;

        # if you do this in production, dont put secrets in this file because it will be written to the world readable nix store
        # environment.etc."ocis/ocis.env".text = '''';

        services.bagage = {
          enable = true;
          environment = { };
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("bagage.service")
      machine.wait_for_open_port(7947)
      # wait for bagage to fully come up
      machine.sleep(5)

      with subtest("garage works"):
          machine.succeed("${lib.getExe pkgs.garage} version")
    '';
  }
)
