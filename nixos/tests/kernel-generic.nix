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
        assert "${linuxPackages.kernel.version}" in machine.succeed("uname -a")
      '';
  }));
in
with pkgs; {
  linux_5_11 = makeKernelTest "5.11" linuxPackages_5_11;
}
