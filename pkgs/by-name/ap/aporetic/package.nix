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
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "aporetic";
    tag = version;
    hash = "sha256-1BbuC/mWEcXJxzDppvsukhNtdOLz0QosD6QqI/93Khc=";
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
              tag = "v33.2.2";
              hash = "sha256-dhMTcceHru/uLHRY4eWzFV+73ckCBBnDlizP3iY5w5w=";
            };

            npmDepsHash = "sha256-5DcMV9N16pyQxRaK6RCoeghZqAvM5EY1jftceT/bP+o=";
          }
        );
    });
in
symlinkJoin {
  inherit pname version;

  paths = (map makeIosevkaFont sets);

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
