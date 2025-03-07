{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-fcitx5";
  version = "0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fcitx5";
    rev = "3471b918d4b5aab2d3c3dd9f2c3b9c18fb470e8e";
    hash = "sha256-1IqFVTEY6z8yNjpi5C+wahMN1kpt0OJATy5echjPXmc=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fcitx5
    cp -r src $out/share/fcitx5/themes
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Soothing pastel theme for Fcitx5";
    homepage = "https://github.com/catppuccin/fcitx5";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pluiedev
      Guanran928
    ];
    platforms = lib.platforms.all;
  };
}
