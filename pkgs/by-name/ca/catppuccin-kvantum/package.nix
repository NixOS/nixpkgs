{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  accent ? "blue",
  variant ? "frappe",
}: let
  pname = "catppuccin-kvantum";
in
  lib.checkListOfEnum "${pname}: theme accent" ["blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow"] [accent]
  lib.checkListOfEnum "${pname}: color variant" ["latte" "frappe" "macchiato" "mocha"] [variant]

  stdenvNoCC.mkDerivation {
    inherit pname;
    version = "0-unstable-2024-10-25";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "Kvantum";
      rev = "a87694e0a3c97644dbb34f8835112d17b54ace68";
      hash = "sha256-eQmEeKC+L408ajlNg3oKMnDK6Syy2GV6FrR2TN5ZBCg=";
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
