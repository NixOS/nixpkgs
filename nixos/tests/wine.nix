{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; config = { }; }
}:

let
  inherit (pkgs.lib) concatMapStrings listToAttrs;
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  hello32 = "${pkgs.pkgsCross.mingw32.hello}/bin/hello.exe";
  hello64 = "${pkgs.pkgsCross.mingwW64.hello}/bin/hello.exe";

  makeWineTest = packageSet: exes: variant: rec {
    name = "${packageSet}-${variant}";
    value = makeTest {
      inherit name;
      meta = with pkgs.lib.maintainers; { maintainers = [ chkno ]; };

      machine = { pkgs, ... }: {
        environment.systemPackages = [ pkgs."${packageSet}"."${variant}" ];
        virtualisation.diskSize = "800";
      };

      testScript = ''
        machine.wait_for_unit("multi-user.target")
        ${concatMapStrings (exe: ''
          greeting = machine.succeed(
              "bash -c 'wine ${exe} 2> >(tee wine-stderr >&2)'"
          )
          assert 'Hello, world!' in greeting
          machine.fail(
              "fgrep 'Could not find Wine Gecko. HTML rendering will be disabled.' wine-stderr"
          )
        '') exes}
      '';
    };
  };

  variants = [ "base" "full" "minimal" "staging" "unstable" "wayland" ];

in listToAttrs (map (makeWineTest "winePackages" [ hello32 ]) variants
  ++ map (makeWineTest "wineWowPackages" [ hello32 hello64 ]) variants)
