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
    version = "0-unstable-2024-10-10";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "bdaa531318d5756cea5674a750a99134dad0bbbc";
      hash = "sha256-O85y8Gg0l+xQP1eQi9GizuKfLEGePZ3wPdBNR+0V4ZQ=";
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
