import ./make-test.nix ({ pkgs, ...} : {
  name = "kernel-copperhead";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { config, lib, pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_hardened_copperhead;
    };

  testScript =
    ''
      $machine->succeed("uname -a");
      $machine->succeed("uname -s | grep 'Linux'");
      $machine->succeed("uname -a | grep '${pkgs.linuxPackages_hardened_copperhead.kernel.modDirVersion}'");
      $machine->succeed("uname -a | grep 'hardened'");
    '';
})
