{ pkgs, ... }:
{
  name = "rstudio-server-test";
  meta.maintainers = with pkgs.lib.maintainers; [
    jbedo
    cfhammill
  ];

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.rstudio-server.enable = true;
    };

  nodes.customPackageMachine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.rstudio-server = {
        enable = true;
        package = pkgs.rstudioServerWrapper.override { packages = [ pkgs.rPackages.ggplot2 ]; };
      };
    };

  testScript = ''
    machine.wait_for_unit("rstudio-server.service")
    machine.succeed("curl -f -vvv -s http://127.0.0.1:8787")

    customPackageMachine.wait_for_unit("rstudio-server.service")
    customPackageMachine.succeed("curl -f -vvv -s http://127.0.0.1:8787")
  '';
}
