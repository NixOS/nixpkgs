# Miscellaneous small tests that don't warrant their own VM run.
{ pkgs, ... }:

let
  inherit (pkgs) lib;
  tests.default = testsForPackage { nixPackage = pkgs.nix; };

  testsForPackage = args: {
    # If the attribute is not named 'test'
    # You will break all the universe on the release-*.nix side of things.
    # `discoverTests` relies on `test` existence to perform a `callTest`.
    test = testMiscFeatures args // {
      passthru.override = args': (testsForPackage (args // args')).test;
    };
  };

  testMiscFeatures =
    { nixPackage, ... }:
    pkgs.testers.nixosTest (
      let
        foo = pkgs.writeText "foo" "Hello World";
      in
      {
        name = "${nixPackage.pname}-misc";
        meta.maintainers = with lib.maintainers; [
          raitobezarius
          artturin
        ];

        nodes.machine =
          { lib, ... }:
          {
            system.extraDependencies = [ foo ];

            nix.package = nixPackage;
          };

        testScript = ''
          import json

          def get_path_info(path):
              result = machine.succeed(f"nix --option experimental-features nix-command path-info --json {path}")
              parsed = json.loads(result)
              return parsed

          with subtest("nix-db"):
              out = "${foo}"
              info = get_path_info(out)
              print(info)

              pathinfo = info[0] if isinstance(info, list) else info[out]

              if (
                  pathinfo["narHash"]
                  != "sha256-BdMdnb/0eWy3EddjE83rdgzWWpQjfWPAj3zDIFMD3Ck="
              ):
                  raise Exception("narHash not set")

              if pathinfo["narSize"] != 128:
                  raise Exception("narSize not set")

          with subtest("nix-db"):
              machine.succeed("nix-store -qR /run/current-system | grep nixos-")
        '';
      }
    );
in
tests
