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
  qtcharts,
  qtdeclarative,
  qtwayland,
  qtwebengine,
  qtwebview,
  wavpack,
  wrapQtAppsHook,
}:

let
  version = "5.13.0-35";
  srcs = {
    aarch64-linux = fetchurl {
      url = "https://signalyst.com/bins/bookworm/hqplayer5desktop_${version}_arm64.deb";
      hash = "sha256-ofS+EDNHKv94GSi9DrZPUhosAZsjSuP8rQghldKZmkU=";
    };
    x86_64-linux = fetchurl {
      url = "https://signalyst.com/bins/noble/hqplayer5desktop_${version}_amd64.deb";
      hash = "sha256-ej4H7SuDMkihlJsHcvPIFSGghyqCvVY/7LbCdq6lky4=";
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
    wrapQtAppsHook
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
    qtcharts
    qtdeclarative
    qtwayland
    qtwebengine
    qtwebview
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

    # pixmaps
    mkdir -p "$out/share/pixmaps"
    mv ./usr/share/pixmaps/* "$out/share/pixmaps"

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

  meta = with lib; {
    homepage = "https://www.signalyst.com";
    description = "High-end upsampling multichannel software HD-audio player";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
