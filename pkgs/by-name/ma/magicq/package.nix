{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  dpkg,
  alsa-lib-with-plugins,
  ffmpeg_4,
  libGL,
  libGLU,
  libarchive,
  libgcc,
  libsForQt5,
  qt5,
  libusb-compat-0_1,
  libusb1,
  libz,
  portaudio,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "magicq";
  version = "1.9.7.3";
  src_version = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;

  src = fetchurl {
    url = "https://secure.chamsys.co.uk/downloads/v${finalAttrs.src_version}/magicq_ubuntu_v${finalAttrs.src_version}.deb";
    hash = "sha256-FsVSt9iIhwL/wI2XYmKJrA7800wFQ2qJ/uF3bbMLw0Q=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib-with-plugins
    ffmpeg_4
    libGL
    libGLU
    libarchive
    libgcc
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtmultimedia
    qt5.qtbase
    libusb-compat-0_1
    libusb1
    libz
    portaudio
  ];

  installPhase = ''
    mkdir $out
    cp -r . $out
    rm -r $out/opt/magicq/lib
    rm $out/opt/magicq/plugins/imageformats/libqtiff.so
    rm $out/opt/magicq/plugins/printsupport/libcupsprintersupport.so
    rm $out/opt/magicq/plugins/mediaservice/libgstcamerabin.so
    mv $out/usr/share $out/share
    runHook postInstall
  '';

  postFixup = ''
    mkdir $out/bin
    makeWrapper $out/opt/magicq/bin/mqqt $out/bin/magicq \
    --chdir $out/opt/magicq
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
