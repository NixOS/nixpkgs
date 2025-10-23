{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  copyDesktopItems,
  makeWrapper,
  flac,
  libmpeg2,
  libmpg123,
  libpng,
  libserialport,
  portmidi,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amiberry";
  version = "5.7.4";

  src = fetchFromGitHub {
    owner = "BlitterStudio";
    repo = "amiberry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EOoVJYefX2pQ2Zz9bLD1RS47u/+7ZWTMwZYha0juF64=";
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    flac
    libmpeg2
    libmpg123
    libpng
    libserialport
    portmidi
    SDL2
    SDL2_image
    SDL2_ttf
  ];

  enableParallelBuilding = true;

  # Amiberry has traditionally behaved as a "Portable" app, meaning that it was designed to expect everything
  # under the same directory. This is not compatible with Nix package conventions.
  # The Amiberry behavior has changed since versions 5.7.4 and 6.3.4 (see
  # https://github.com/BlitterStudio/amiberry/wiki/FAQ#q-where-does-amiberry-look-for-its-files-can-i-change-that
  # for more information), however this is still not compatible with Nix packaging. The AMIBERRY_DATA_DIR can go
  # in the nix store but the Amiberry configuration files must be stored in a user writable location.
  # Fortunately Amiberry provides environment variables for specifying these locations which we can supply with the
  # wrapper script below.
  # One more caveat: Amiberry expects the configuration files path (AMIBERRY_HOME_DIR) to exist, otherwise it will
  # fall back to behaving like a "Portable" app. The wrapper below ensures that the AMIBERRY_HOME_DIR path exists,
  # preventing that fallback.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp amiberry $out/bin/
    cp -r abr data $out/
    install -Dm444 data/amiberry.png $out/share/icons/hicolor/256x256/apps/amiberry.png
    wrapProgram $out/bin/amiberry \
      --set-default AMIBERRY_DATA_DIR $out \
      --run 'AMIBERRY_HOME_DIR="$HOME/.amiberry"' \
      --run 'mkdir -p \
        $AMIBERRY_HOME_DIR/kickstarts \
        $AMIBERRY_HOME_DIR/conf \
        $AMIBERRY_HOME_DIR/nvram \
        $AMIBERRY_HOME_DIR/plugins \
        $AMIBERRY_HOME_DIR/screenshots \
        $AMIBERRY_HOME_DIR/savestates \
        $AMIBERRY_HOME_DIR/controllers \
        $AMIBERRY_HOME_DIR/whdboot \
        $AMIBERRY_HOME_DIR/lha \
        $AMIBERRY_HOME_DIR/floppies \
        $AMIBERRY_HOME_DIR/cdroms \
        $AMIBERRY_HOME_DIR/harddrives'
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "amiberry";
      desktopName = "Amiberry";
      exec = "amiberry";
      comment = "Amiga emulator";
      icon = "amiberry";
      categories = [
        "System"
        "Emulator"
      ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/BlitterStudio/amiberry";
    description = "Optimized Amiga emulator for Linux/macOS";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "amiberry";
  };
})
