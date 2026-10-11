{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  dpkg,
  alsa-lib-with-plugins,
  ffmpeg_8,
  libGL,
  libGLU,
  libarchive,
  libgcc,
  qt6,
  qt6Packages,
  libusb-compat-0_1,
  libusb1,
  libz,
  portaudio,
  libtommath,
  kissfftFloat,
  pugixml,
  pipewire,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "magicq";
  version = "1.9.9.0";
  src_version = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;

  src = fetchurl {
    url = "https://secure.chamsys.co.uk/downloads/v${finalAttrs.src_version}/magicq_ubuntu_v${finalAttrs.src_version}.deb";
    hash = "sha256-0aXbTrQJY+6l202NLw1PjxOFUgl5lUHz5G3RbGDNRkw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib-with-plugins
    ffmpeg_8
    libGL
    libGLU
    libarchive
    libgcc
    libtommath
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwayland
    qt6.qt5compat
    qt6.qt3d
    qt6Packages.qzxing
    libusb-compat-0_1
    libusb1
    libz
    portaudio
    kissfftFloat
    (pugixml.override {
      shared = true;
    })
  ];

  installPhase = ''
    mkdir $out
    cp -r . $out
    rm -r $out/opt/magicq/lib/*
    mv $out/usr/share $out/share
    runHook postInstall
  '';

  postFixup = ''
    # Fix magicq searching for the lower-case library name
    ln -s ${qt6Packages.qzxing}/lib/libQZXing.so \
    $out/opt/magicq/lib/libqzxing.so

    mkdir $out/bin
    makeWrapper $out/opt/magicq/bin/mqqt $out/bin/magicq \
      --chdir $out/opt/magicq \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pipewire ]}

    wrapQtApp $out/bin/magicq
    sed "s|@out@|$out|g" -i $out/share/applications/magicq.desktop
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "magicq";
      desktopName = "MagicQ by ChamSys Ltd.";
      genericName = "MagicQ";
      exec = "@out@/bin/magicq";
      path = "@out@/opt/magicq/";
      icon = "magicq";
      categories = [
        "AudioVideo"
        "Qt"
      ];
    })
  ];

  meta = {
    description = "MagicQ Lighting Console Software";
    homepage = "https://chamsyslighting.com/product/magicq-software/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "magicq";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ panakotta00 ];
  };
})
