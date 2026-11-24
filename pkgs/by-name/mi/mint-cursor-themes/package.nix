{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "mint-cursor-themes";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-cursor-themes";
    # They don't really do tags, this is just a named commit.
    rev = "55d7d8f80ccaaab4d7b623050a885e9954969491";
    hash = "sha256-bwxhUVYNESS2GIy3rp0BRQB1+peoJ1T3HLYgg0zj3XU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/linuxmint/mint-cursor-themes/";
    description = "Linux Mint cursor themes";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.cinnamon ];
    platforms = lib.platforms.linux;
  };
}
