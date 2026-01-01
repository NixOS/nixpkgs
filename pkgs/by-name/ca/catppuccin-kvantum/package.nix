{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  accent ? "blue",
  variant ? "frappe",
}:
let
  pname = "catppuccin-kvantum";
in
lib.checkListOfEnum "${pname}: theme accent"
  [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ]
  [ accent ]
  lib.checkListOfEnum
  "${pname}: color variant" [ "latte" "frappe" "macchiato" "mocha" ] [ variant ]

  stdenvNoCC.mkDerivation
  {
    inherit pname;
<<<<<<< HEAD
    version = "0-unstable-2025-12-27";
=======
    version = "0-unstable-2025-11-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "Kvantum";
<<<<<<< HEAD
      rev = "71105d224fef95dd023691303477ce3eea487457";
      hash = "sha256-gcvCVZjVbj5fRZWaM+mZTwH/g158MH36JmMuMgCBuqQ=";
=======
      rev = "1156e5437435282b47ac6856acd9d0feef1ed929";
      hash = "sha256-V5Upqkil9Q2MeEPtEAemirbJxnEyYcM3Z8jiyz//ccw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/Kvantum
      cp -a themes/catppuccin-${variant}-${accent} $out/share/Kvantum
      runHook postInstall
    '';

    passthru.updateScript = unstableGitUpdater { };

    meta = {
      description = "Soothing pastel theme for Kvantum";
      homepage = "https://github.com/catppuccin/Kvantum";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      maintainers = [ lib.maintainers.bastaynav ];
    };
  }
