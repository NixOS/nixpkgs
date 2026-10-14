{
  pkgs,
  lib,
  runTest,
}:

let
  inherit (lib)
    concatMapStrings
    listToAttrs
    optionals
    optionalString
    ;

  hello32 = "${pkgs.pkgsCross.mingw32.hello}/bin/hello.exe";
  hello64 = "${pkgs.pkgsCross.mingwW64.hello}/bin/hello.exe";

  makeWineTest = packageSet: exes: variant: rec {
    name = "${packageSet}-${variant}";
    value = runTest {
      inherit name;
      meta = with lib.maintainers; {
        maintainers = [ chkno ];
      };

      nodes.machine =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs."${packageSet}"."${variant}" ];
          virtualisation.diskSize = 800;
        };

      testScript = ''
        machine.wait_for_unit("multi-user.target")
        ${concatMapStrings (
          exe:
          ''
            greeting = machine.succeed(
                "bash -c 'wine ${exe} 2> >(tee wine-stderr >&2)'"
            )
            assert 'Hello, world!' in greeting
          ''
          # only the full version contains Gecko, but the error is not printed reliably in other variants
          + optionalString (variant == "full") ''
            machine.fail(
                "fgrep 'Could not find Wine Gecko. HTML rendering will be disabled.' wine-stderr"
            )
          ''
        ) exes}
      '';
    };
  };

  variants = [
    "base"
    "full"
    "minimal"
    "staging"
    "unstable"
    "wayland"
  ];

in
listToAttrs (
  map (makeWineTest "winePackages" [ hello32 ]) variants
  ++ optionals pkgs.stdenv.hostPlatform.is64bit (
    map
      (makeWineTest "wineWow64Packages" [
        hello32
        hello64
      ])
      # This wayland combination times out after spending many hours.
      # https://hydra.nixos.org/job/nixos/trunk-combined/nixos.tests.wine.wineWowPackages-wayland.x86_64-linux
      (lib.remove "wayland" variants)
  )
)
