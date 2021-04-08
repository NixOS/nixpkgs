{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with pkgs.lib;

let
  makeKernelTest = version: linuxPackages: (import ./make-test-python.nix ({ pkgs, ... }: {
    name = "kernel-${version}";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus ];
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
  }));
in
with pkgs; {
  linux_4_4 = makeKernelTest "4.4" linuxPackages_4_4;
  linux_4_9 = makeKernelTest "4.9" linuxPackages_4_9;
  linux_4_14 = makeKernelTest "4.14" linuxPackages_4_14;
  linux_4_19 = makeKernelTest "4.19" linuxPackages_4_19;
  linux_5_4 = makeKernelTest "5.4" linuxPackages_5_4;
  linux_5_10 = makeKernelTest "5.10" linuxPackages_5_10;
  linux_5_11 = makeKernelTest "5.11" linuxPackages_5_11;

  linux_testing = makeKernelTest "testing" linuxPackages_testing;
}
