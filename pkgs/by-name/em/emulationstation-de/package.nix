{
  lib,
  stdenv,
  cmake,
  fetchzip,
  pkg-config,
  alsa-lib,
  curl,
  ffmpeg,
  freeimage,
  freetype,
  libgit2,
  poppler,
  pugixml,
  SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emulationstation-de";
  version = "3.0.2";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v${finalAttrs.version}/emulationstation-de-v${finalAttrs.version}.tar.gz";
    hash = "sha256:RGlXFybbXYx66Hpjp2N3ovK4T5VyS4w0DWRGNvbwugs=";
  };

  patches = [ ./001-add-nixpkgs-retroarch-cores.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    curl
    ffmpeg
    freeimage
    freetype
    libgit2
    poppler
    pugixml
    SDL2
  ];

  installPhase = ''
    # Binary
    install -D ../es-de $out/bin/es-de

    # Resources
    mkdir -p $out/share/es-de/
    cp -r ../resources/ $out/share/es-de/resources/

    # Desktop file
    mkdir -p $out/share/applications
    cp ../es-app/assets/org.es_de.frontend.desktop $out/share/applications/

    # Icon
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ../es-app/assets/org.es_de.frontend.svg $out/share/icons/hicolor/scalable/apps/
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/org.es_de.frontend.desktop \
      --replace "Exec=es-de" "Exec=$out/bin/es-de"
  '';

  meta = {
    description = "EmulationStation Desktop Edition is a frontend for browsing and launching games from your multi-platform game collection";
    homepage = "https://es-de.org";
    maintainers = with lib.maintainers; [ ivarmedi ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "es-de";
  };
})
