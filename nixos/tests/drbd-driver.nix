import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "drbd-driver";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ birkb ];
  };

  nodes = {
    machine = { config, pkgs, ... }: {
      boot.kernelModules = [ "drbd" ];
      boot.extraModulePackages = with config.boot.kernelPackages; [ drbd ];
      boot.kernelPackages = pkgs.linuxPackages;
    };
  };

  testScript = ''
    machine.start();
    machine.succeed("modinfo drbd | grep --extended-regexp '^version:\s+${pkgs.linuxPackages.drbd.version}$'")
  '';
})
