{ lib, pkgs, ... }:
{
  name = "drbd-driver";
  meta.maintainers = with pkgs.lib.maintainers; [ birkb ];

  nodes = {
    machine =
      { config, pkgs, ... }:
      {
        boot = {
          kernelModules = [ "drbd" ];
          extraModulePackages = with config.boot.kernelPackages; [ drbd ];
          kernelPackages = pkgs.linuxPackages;
        };
      };
  };

  testScript = ''
    machine.start();
    machine.succeed("modinfo drbd | grep --extended-regexp '^version:\s+${pkgs.linuxPackages.drbd.version}$'")
  '';
}
