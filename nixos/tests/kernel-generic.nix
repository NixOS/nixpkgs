{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}@args:

with pkgs.lib;

let
  testsForLinuxPackages = linuxPackages: (import ./make-test-python.nix ({ pkgs, ... }: {
    name = "kernel-${linuxPackages.kernel.version}";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus atemu ];
    };

    machine = { ... }:
      {
        boot.kernelPackages = linuxPackages;
      };

    testScript =
      ''
        assert "Linux" in machine.succeed("uname -s")
        assert "${linuxPackages.kernel.modDirVersion}" in machine.succeed("uname -a")
      '';
  }) args);
  kernels = {
    inherit (pkgs)
      linuxPackages_4_4
      linuxPackages_4_9
      linuxPackages_4_14
      linuxPackages_4_19
      linuxPackages_5_4
      linuxPackages_5_10
      linuxPackages_5_13
      linuxPackages_5_14

      linuxPackages_4_14_hardened
      linuxPackages_4_19_hardened
      linuxPackages_5_4_hardened
      linuxPackages_5_10_hardened

      linuxPackages_testing;
  };

in mapAttrs (_: lP: testsForLinuxPackages lP) kernels // {
  inherit testsForLinuxPackages;

  testsForKernel = kernel: testsForLinuxPackages (pkgs.linuxPackagesFor kernel);
}
