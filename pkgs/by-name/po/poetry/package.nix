{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:

let
  newPackageOverrides =
    self: super:
    {
      poetry = self.callPackage ./unwrapped.nix { };

      # The versions of Poetry and poetry-core need to match exactly,
      # and poetry-core in nixpkgs requires a staging cycle to be updated,
      # so apply an override here.
      #
      # We keep the override around even when the versions match, as
      # it's likely to become relevant again after the next Poetry update.
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = "2.2.1";
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = "poetry-core";
          tag = version;
          hash = "sha256-l5WTjKa+A66QfWLmrjCQq7ZrSaeuylGIRZr8jsiYq+A=";
        };
      });
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
      poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
      poetry-plugin-export = callPackage ./plugins/poetry-plugin-export.nix { };
      poetry-plugin-up = callPackage ./plugins/poetry-plugin-up.nix { };
      poetry-plugin-poeblix = callPackage ./plugins/poetry-plugin-poeblix.nix { };
      poetry-plugin-shell = callPackage ./plugins/poetry-plugin-shell.nix { };
    };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. poetry.withPlugins (ps: with ps; [ poetry-plugin-up ])
  withPlugins =
    selector:
    let
      selected = selector (plugins python.pkgs);
    in
    python.pkgs.toPythonApplication (
      python.pkgs.poetry.overridePythonAttrs (old: {
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
