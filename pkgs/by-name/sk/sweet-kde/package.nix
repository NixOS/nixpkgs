{
  fetchFromGitHub,
  gitUpdater,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "sweet-kde";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet-kde";
    rev = "9f311e1497c749c5463007dcaf15c06376b4db5f";
    hash = "sha256-rGDXRZiIddn2t8mVQNdwpe/loe+9IIe++E7BGu42AKA=";
  };

  buildPhase = ''
    runHook preBuild
    mkdir -p plasma/desktoptheme/Sweet
    mv dialogs plasma/desktoptheme/Sweet/dialogs
    mv icons plasma/desktoptheme/Sweet/icons
    mv preview plasma/desktoptheme/Sweet/preview
    mv widgets plasma/desktoptheme/Sweet/widgets
    mv colors plasma/desktoptheme/Sweet/colors
    mv metadata.desktop plasma/desktoptheme/Sweet/metadata.desktop
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/share
    cp -r plasma $out/share
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Sweet plasma style theme";
    homepage = "https://github.com/EliverLara/Sweet-kde";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.raducu42 ];
    platforms = lib.platforms.all;
  };
}
