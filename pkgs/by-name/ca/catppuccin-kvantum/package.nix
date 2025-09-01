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
    version = "0-unstable-2025-08-09";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "48246af7ad19a6b9cde04526a9b57afdecfa0b7b";
      hash = "sha256-Axjl2jQinpazVz8w7yFSWkjG/CnmEMmcmrACJrdS1zg=";
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
