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
    version = "0-unstable-2025-08-18";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "c7cb144b041395e83e4f510a62526b7adfb79911";
      hash = "sha256-YNUkri+no+rNLTJHf6cPdy4AmQLzPiRK1Jbp2o8e1LE=";
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
