{ system ? builtins.currentSystem, pkgs ? import ../.. {
  inherit system;
  config = { };
}, }:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  makeWineTest = variant:
    makeTest {
      name = "wine-${variant}";
      meta = with pkgs.lib.maintainers; { maintainers = [ chkno ]; };

      machine = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.winePackages."${variant}" ];
      };

      testScript = ''
        machine.wait_for_unit("multi-user.target")
        greeting = machine.succeed(
            'wine ${pkgs.pkgsCross.mingw32.hello}/bin/hello.exe'
        )
        assert 'Hello, world!' in greeting
      '';
    };
in pkgs.lib.genAttrs [ "base" "full" "minimal" "staging" "unstable" ]
makeWineTest
