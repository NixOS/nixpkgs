{ lib, python3 }:
let
  newPackageOverrides =
    self: super:
    {
      hatch = self.callPackage ./unwrapped.nix { };
    }
    // (plugins self);

  python = python3.override (old: {
    self = python;
    packageOverrides = lib.composeManyExtensions (
      (if old ? packageOverrides then [ old.packageOverrides ] else [ ]) ++ [ newPackageOverrides ]
    );
  });

  plugins =
    ps: with ps; {
      hatch-pip-compile = callPackage ./plugins/hatch-pip-compile.nix { };
    };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. hatch.withPlugins (ps: with ps; [ hatch-pip-compile ])
  withPlugins =
    selector:
    let
      selected = selector (plugins python.pkgs);
    in
    python.pkgs.toPythonApplication (
      python.pkgs.hatch.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ selected;

        # save some build time when adding plugins by disabling tests
        doCheck = selected == [ ];

        # Propagating dependencies leaks them through $PYTHONPATH which causes issues
        # when used in nix-shell.
        postFixup = ''
          rm $out/nix-support/propagated-build-inputs
        '';

        passthru = {
          plugins = plugins python.pkgs;
          inherit withPlugins python;
        };
      })
    );
in
withPlugins (ps: [ ])
