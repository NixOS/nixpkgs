{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}@args:

with pkgs.lib;

let
  stapScript = pkgs.writeText "test.stp" ''
    probe begin {
      println("println works")
      exit()
    }
  '';

  ## TODO shared infra with ../kernel-generic.nix
  testsForLinuxPackages = linuxPackages: (import ./make-test-python.nix ({ pkgs, ... }: {
    name = "kernel-${linuxPackages.kernel.version}";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bendlas ];
    };

    nodes.machine = { ... }:
      {
        boot.kernelPackages = linuxPackages;
        programs.systemtap.enable = true;
      };

    testScript =
      ''
        with subtest("Capture stap ouput"):
            output = machine.succeed("stap ${stapScript} 2>&1")

        with subtest("Ensure that expected output from stap script is there"):
            assert "println works\n" == output, "println works\n != " + output
      '';
  }) args);

  ## TODO shared infra with ../kernel-generic.nix
  kernels = {
    inherit (pkgs.linuxKernel.vanillaPackages)
      linux_6_1 linux_6_6
    ;
    inherit (pkgs.linuxKernel.packages)
      linux_rt_6_1 linux_6_1_hardened
      linux_libre linux_testing
    ;
  };

in mapAttrs (_: lP: testsForLinuxPackages lP) kernels // {
  passthru = {
    inherit testsForLinuxPackages;

    testsForKernel = kernel: testsForLinuxPackages (pkgs.linuxPackagesFor kernel);
  };
}
