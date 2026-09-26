# Run tests: nix-build -A tests.nixosOptionsDoc

{
  lib,
  nixosOptionsDoc,
  runCommand,
}:
let
  inherit (lib) mkOption types;

  eval = lib.evalModules {
    modules = [
      {
        options.foo.bar.enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable the foo bar feature.
          '';
        };
      }
    ];
  };

  doc = nixosOptionsDoc {
    inherit (eval) options;
  };
in
{
  /**
    Test that
      - the `nixosOptionsDoc` function can be invoked
      - integration of the module system and `nixosOptionsDoc` (limited coverage)

    The more interesting tests happen in the `nixos-render-docs` package.
  */
  commonMark =
    runCommand "test-nixosOptionsDoc-commonMark"
      {
        commonMarkDefault = doc.optionsCommonMark;
        commonMarkAnchors = doc.optionsCommonMark.overrideAttrs {
          extraArgs = [
            "--anchor-prefix"
            "my-opt-"
            "--anchor-style"
            "legacy"
          ];
        };
      }
      ''
        env | grep ^commonMark | sed -e 's/=/ = /'
        (
          set -x
          grep -F 'foo\.bar\.enable' $commonMarkDefault >/dev/null
          grep -F '{#my-opt-foo.bar.enable}' $commonMarkAnchors >/dev/null
        )
        touch $out
      '';
}
