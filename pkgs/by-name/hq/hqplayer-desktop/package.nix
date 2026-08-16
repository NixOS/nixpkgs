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
  latestDebianCodename = "trixie";
  latestUbuntuCodename = "noble";
  version = "6.0.2-3";
  majorVersion = lib.versions.major version;
  srcs = {
    aarch64-linux = fetchurl {
      url = "https://signalyst.com/bins/${latestDebianCodename}/hqplayer${majorVersion}desktop_${version}_arm64.deb";
      hash = "sha256-remml9wtBrJXiSA96rBjf0tbVJquskq2o+kmeAxI84M=";
    };
    x86_64-linux = fetchurl {
      url = "https://signalyst.com/bins/${latestUbuntuCodename}/hqplayer${majorVersion}desktop_${version}_amd64.deb";
      hash = "sha256-Lx0E7lM7lLl44s7+T17JJmjKzdKmXJbD5iXDBJelT24=";
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

    # The binary links against libomp.so.5, which is not provided by
    # `llvmPackages.openmp`; provide it as a symlink so that
    # `autoPatchelfHook` can resolve it.
    mkdir -p "$out"/lib
    ln --symbolic \
      ${lib.getLib llvmPackages.openmp}/lib/libomp.so \
      "$out"/lib/libomp.so.5
    addAutoPatchelfSearchPath "$out"/lib

    # documentation
    mkdir -p "$doc/share/doc/hqplayer-desktop" "$doc/share/applications"
    mv ./usr/share/doc/hqplayer6desktop/* "$doc/share/doc/hqplayer-desktop"
    mv ./usr/share/applications/hqplayer6desktop-manual.desktop "$doc/share/applications"

    # desktop files
    mkdir -p "$out/share/applications"
    mv ./usr/share/applications/* "$out/share/applications"

    # icons
    mkdir -p $out/share/icons/hicolor/96x96/apps
    install -D ./usr/share/pixmaps/hqplayer6client.png -t $out/share/icons/hicolor/128x128/apps
    install -D ./usr/share/pixmaps/hqplayer6desktop.png -t $out/share/icons/hicolor/128x128/apps
    magick ./usr/share/pixmaps/hqplayer6desktop-manual.png -resize 96x96 $out/share/icons/hicolor/96x96/apps/hqplayer6desktop-manual.png
    runHook postInstall
  '';

  # doc has dependencies on evince that is not required by main app
  outputs = [
    "out"
    "doc"
  ];

  postInstall = ''
    for desktopFile in $out/share/applications/hqplayer6{client,desktop}.desktop; do
      substituteInPlace "$desktopFile" \
        --replace /usr/bin "$out"/bin
    done
    substituteInPlace "$doc/share/applications/hqplayer6desktop-manual.desktop" \
        --replace /usr/share/doc/hqplayer6desktop "$doc/share/doc/hqplayer-desktop" \
        --replace evince "${evince}/bin/evince"
  '';

  meta = {
    homepage = "https://www.signalyst.com";
    description = "High-end upsampling multichannel software HD-audio player";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [
      lovesegfault
      yiyu
    ];
  };
}
