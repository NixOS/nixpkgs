{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}@args:

with pkgs.lib;

let
  testsForLinuxPackages = linuxPackages: (import ./make-test-python.nix ({ pkgs, ... }: {
    name = "kernel-${linuxPackages.kernel.version}";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus atemu ma27 ];
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
      linux_6_1_hardened
      linux_6_4_hardened
      linux_6_5_hardened
      linux_rt_5_4
      linux_rt_5_10
      linux_rt_5_15
      linux_rt_6_1
      linux_libre

      linux_testing;
  };

in mapAttrs (_: lP: testsForLinuxPackages lP) kernels // {
  passthru = {
    inherit testsForLinuxPackages;

    testsForKernel = kernel: testsForLinuxPackages (pkgs.linuxPackagesFor kernel);
  };
}
