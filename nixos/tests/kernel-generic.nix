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

    nodes.machine = { ... }:
      {
        boot.kernelPackages = linuxPackages;
      };

    testScript =
      ''
        assert "Linux" in machine.succeed("uname -s")
        assert "${linuxPackages.kernel.modDirVersion}" in machine.succeed("uname -a")
      '';
  }) args);
  kernels = pkgs.linuxKernel.vanillaPackages // {
    inherit (pkgs.linuxKernel.packages)
      linux_4_14_hardened
      linux_4_19_hardened
      linux_5_4_hardened
      linux_5_10_hardened
      linux_5_15_hardened
      linux_6_0_hardened
      linux_6_1_hardened

      linux_testing;
  };

in mapAttrs (_: lP: testsForLinuxPackages lP) kernels // {
  inherit testsForLinuxPackages;

  testsForKernel = kernel: testsForLinuxPackages (pkgs.linuxPackagesFor kernel);
}
