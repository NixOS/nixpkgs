{
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  dpkg,
  evince,
  fetchurl,
  flac,
  lib,
  libmicrohttpd,
  libogg,
  libusb-compat-0_1,
  llvmPackages,
  mpfr,
  wavpack,
  kdePackages,
  imagemagick,
}:

let
  version = "5.16.2-43";
  srcs = {
    aarch64-linux = fetchurl {
      url = "https://signalyst.com/bins/trixie/hqplayer5desktop_${version}_arm64.deb";
      hash = "sha256-dmnDbFf1obuBvKSMIGFiI7fXi/5YRP23625Y+UEj+Wo=";
    };
    x86_64-linux = fetchurl {
      url = "https://signalyst.com/bins/noble/hqplayer5desktop_${version}_amd64.deb";
      hash = "sha256-WUqfMUQSVb+MSc0GyhuEMM9H6fJP/NcmpFAX46BCiPI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "hqplayer-desktop";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    kdePackages.wrapQtAppsHook
    imagemagick
  ];

  buildInputs = [
    alsa-lib
    flac
    stdenv.cc.cc.lib
    libmicrohttpd
    libogg
    libusb-compat-0_1
    llvmPackages.openmp
    mpfr
    kdePackages.qtcharts
    kdePackages.qtdeclarative
    kdePackages.qtwayland
    kdePackages.qtwebengine
    kdePackages.qtwebview
    wavpack
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main executable
    mkdir -p "$out"/bin
    mv ./usr/bin/* "$out"/bin

    # documentation
    mkdir -p "$doc/share/doc/hqplayer-desktop" "$doc/share/applications"
    mv ./usr/share/doc/hqplayer5desktop/* "$doc/share/doc/hqplayer-desktop"
    mv ./usr/share/applications/hqplayer5desktop-manual.desktop "$doc/share/applications"

    # desktop files
    mkdir -p "$out/share/applications"
    mv ./usr/share/applications/* "$out/share/applications"

    # icons
    mkdir -p $out/share/icons/hicolor/96x96/apps
    install -D ./usr/share/pixmaps/hqplayer5client.png -t $out/share/icons/hicolor/128x128/apps
    install -D ./usr/share/pixmaps/hqplayer5desktop.png -t $out/share/icons/hicolor/128x128/apps
    magick ./usr/share/pixmaps/hqplayer5desktop-manual.png -resize 96x96 $out/share/icons/hicolor/96x96/apps/hqplayer5desktop-manual.png
    runHook postInstall
  '';

  # doc has dependencies on evince that is not required by main app
  outputs = [
    "out"
    "doc"
  ];

  postInstall = ''
    for desktopFile in $out/share/applications/hqplayer5{client,desktop}.desktop; do
      substituteInPlace "$desktopFile" \
        --replace /usr/bin "$out"/bin
    done
    substituteInPlace "$doc/share/applications/hqplayer5desktop-manual.desktop" \
        --replace /usr/share/doc/hqplayer5desktop "$doc/share/doc/hqplayer-desktop" \
        --replace evince "${evince}/bin/evince"
  '';

  postFixup = ''
    patchelf --replace-needed libomp.so.5 libomp.so $out/bin/.hqplayer5*-wrapped
  '';

  meta = {
    homepage = "https://www.signalyst.com";
    description = "High-end upsampling multichannel software HD-audio player";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
