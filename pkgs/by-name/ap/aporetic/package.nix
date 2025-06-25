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
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "aporetic";
    tag = version;
    hash = "sha256-5lPViAo9SztOdds6HEmKJpT17tgcxmU/voXDffxTMDI=";
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
              tag = "v32.5.0";
              hash = "sha256-MzsAkq5l4TP19UJNPW/8hvIqsJd94pADrrv8wLG6NMQ=";
            };

            npmDepsHash = "sha256-HeqwpZyHLHdMhd/UfXVBonMu+PhStrLCxAMuP/KuTT8=";
          }
        );
    });
in
symlinkJoin {
  inherit pname version;

  paths = (builtins.map makeIosevkaFont sets);

  meta = {
    inherit (src.meta) homepage;
    description = ''
      Custom build of Iosevka with different style and metrics than the default, successor to my "Iosevka Comfy" fonts
    '';
    license = lib.licenses.ofl;
    platforms = iosevka.meta.platforms;
    maintainers = [ lib.maintainers.DamienCassou ];
  };
}
