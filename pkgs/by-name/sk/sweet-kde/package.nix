{
  fetchFromGitHub,
  gitUpdater,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "sweet-kde";
  version = "1.0.0";
__structuredAttrs = true;
strictDeps = true;
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet-kde";
    rev = "9f311e1497c749c5463007dcaf15c06376b4db5f";
    hash = "sha256-rGDXRZiIddn2t8mVQNdwpe/loe+9IIe++E7BGu42AKA=";
  };

  installPhase = ''
    mkdir -p "$out/share/plasma/desktoptheme/Sweet"
    cp -rd dialogs icons preview widgets colors metadata.desktop -t "$out/share/plasma/desktoptheme/Sweet"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Sweet plasma style theme";
    homepage = "https://github.com/EliverLara/Sweet-kde";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.raducu427 ];
    platforms = lib.platforms.all;
  };
}
