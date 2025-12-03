{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-qt5ct";
  version = "0-unstable-2025-03-29";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "qt5ct";
    rev = "cb585307edebccf74b8ae8f66ea14f21e6666535";
    hash = "sha256-wDj6kQ2LQyMuEvTQP6NifYFdsDLT+fMCe3Fxr8S783w=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/qt{5,6}ct
    cp -r themes $out/share/qt5ct/colors
    cp -r themes $out/share/qt6ct/colors
    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for qt5ct & qt6ct";
    homepage = "https://github.com/catppuccin/qt5ct";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pluiedev
      nullcube
    ];
    platforms = lib.platforms.all;
  };
}
