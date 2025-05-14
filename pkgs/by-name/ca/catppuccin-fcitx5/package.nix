{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-fcitx5";
  version = "0-unstable-2025-03-22";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fcitx5";
    rev = "383c27ac46cbb55aa5f58acbd32841c1ed3a78a0";
    hash = "sha256-n83f9ge4UhBFlgCPRCXygcVJiDp7st48lAJHTm1ohR4=";
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
