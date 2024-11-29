{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}@args:

with pkgs.lib;

let
  stapScript = pkgs.writeText "test.stp" ''
    probe kernel.function("do_sys_poll") {
      println("kernel function probe & println work")
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
            assert "kernel function probe & println work\n" == output, "kernel function probe & println work\n != " + output
      '';
  }) args);

  ## TODO shared infra with ../kernel-generic.nix
  kernels = {
    inherit (pkgs.linuxKernel.packageAliases) linux_default linux_latest;
  };

in mapAttrs (_: lP: testsForLinuxPackages lP) kernels // {
  passthru = {
    inherit testsForLinuxPackages;

    testsForKernel = kernel: testsForLinuxPackages (pkgs.linuxPackagesFor kernel);
  };
}
