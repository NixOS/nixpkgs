{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; config = { }; }
}:

let
  inherit (pkgs.lib) concatMapStrings listToAttrs optionals;
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;

  hello32 = "${pkgs.pkgsCross.mingw32.hello}/bin/hello.exe";
  hello64 = "${pkgs.pkgsCross.mingwW64.hello}/bin/hello.exe";

  makeWineTest = packageSet: exes: variant: rec {
    name = "${packageSet}-${variant}";
    value = makeTest {
      inherit name;
      meta = with pkgs.lib.maintainers; { maintainers = [ chkno ]; };

      nodes.machine = { pkgs, ... }: {
        environment.systemPackages = [ pkgs."${packageSet}"."${variant}" ];
        virtualisation.diskSize = 800;
      };

      testScript = ''
        machine.wait_for_unit("multi-user.target")
        ${concatMapStrings (exe: ''
          greeting = machine.succeed(
              "machinectl shell ''' /bin/sh -c 'wine ${exe}; echo Exit status $?'"
          )
          assert 'Hello, world!' in greeting, "Didn't find greeting"
          assert 'Exit status 0' in greeting, "Greeting failed"
          assert 'Could not find Wine Gecko. HTML rendering will be disabled.' not in greeting, "Couldn't find Gecko"
        '') exes}
      '';
    };
  };

  variants = [ "base" "full" "minimal" "staging" "unstable" "wayland" ];

in
listToAttrs (
  map (makeWineTest "winePackages" [ hello32 ]) variants
  ++ optionals pkgs.stdenv.is64bit
    (map (makeWineTest "wineWowPackages" [ hello32 hello64 ]) variants)
)
