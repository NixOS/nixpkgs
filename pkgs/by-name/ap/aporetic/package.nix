{
  lib,
  iosevka,
  fetchFromGitHub,
  buildNpmPackage,
  symlinkJoin,
}:

let
  sets = [
    "sans-mono"
    "sans"
    "serif-mono"
    "serif"
  ];
  pname = "aporetic";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = pname;
    rev = version;
    sha256 = "sha256-5m4iT77FFsJf6N1FIsCtk5Z0IEOVUGCceXiT2n5dZUg=";
  };
  privateBuildPlan = src.outPath + "/private-build-plans.toml";
  makeIosevkaFont =
    set:
    let
      superBuildNpmPackage = buildNpmPackage;
    in
    (iosevka.override {
      inherit set privateBuildPlan;
      buildNpmPackage =
        args:
        superBuildNpmPackage (
          args
          // {
            pname = "aporetic-${set}";
            inherit version;

            src = fetchFromGitHub {
              owner = "be5invis";
              repo = "iosevka";
              rev = "v32.5.0";
              hash = "sha256-MzsAkq5l4TP19UJNPW/8hvIqsJd94pADrrv8wLG6NMQ=";
            };

            npmDepsHash = "sha256-HeqwpZyHLHdMhd/UfXVBonMu+PhStrLCxAMuP/KuTT8=";

            meta = with lib; {
              inherit (src.meta) homepage;
              description = ''
                Customised build of the Iosevka typeface, with a consistent rounded style and overrides for almost all individual glyphs in both roman (upright) and italic (slanted) variants.
              '';
              license = licenses.ofl;
              platforms = iosevka.meta.platforms;
              maintainers = [ maintainers.DamienCassou ];
            };
          }
        );
    });
in
symlinkJoin {
  inherit pname version;
  paths = (builtins.map makeIosevkaFont sets);
}
