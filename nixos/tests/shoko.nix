{ runTest }:

{
  default = runTest (
    { lib, ... }:

    {
      name = "Shoko";

      nodes.machine = {
        services.shoko.enable = true;
      };

      testScript = ''
        machine.wait_for_unit("shoko.service")
        machine.wait_for_open_port(8111)
        machine.succeed("curl --fail http://localhost:8111")
      '';

      meta.maintainers = with lib.maintainers; [
        diniamo
        nanoyaki
      ];
    }
  );

  withPlugins = runTest (
    { pkgs, lib, ... }:

    {
      name = "Shoko with plugins";

      nodes.machine = {
        services.shoko = {
          enable = true;
          package = pkgs.shoko.override { withNet9 = true; };
          plugins = with pkgs; [
            luarenamer
            shokofin
          ];
        };
      };

      testScript = ''
        machine.wait_for_unit("shoko.service")
        machine.wait_for_open_port(8111)
        machine.succeed("curl --fail http://localhost:8111")
      '';

      meta.maintainers = with lib.maintainers; [ nanoyaki ];
    }
  );
}
