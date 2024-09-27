{ stdenv
, alsa-lib
, autoPatchelfHook
, dpkg
, evince
, fetchurl
, flac
, lib
, libmicrohttpd
, libusb-compat-0_1
, llvmPackages
, mpfr
, qtcharts
, qtdeclarative
, qtwayland
, qtwebengine
, qtwebview
, wavpack
, wrapQtAppsHook
}:

let
  version = "5.4.0-10";
  srcs = {
    aarch64-linux = fetchurl {
      url = "https://www.signalyst.eu/bins/hqplayer5desktop_${version}_arm64.deb";
      hash = "sha256-yebQWp1qAHlV+D5xfcjIDhGfFhBY52w5u8t/7Iciow8=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.signalyst.eu/bins/hqplayer5desktop_${version}_amd64.deb";
      hash = "sha256-NMvAvfubUppT1VGMU75gNI1Xk74NhXaatGr6p+OscSk=";
    };
  };
in
stdenv.mkDerivation {
  pname = "hqplayer-desktop";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

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

    # additional library
    mkdir -p "$out"/lib
    mv ./opt/hqplayer5desktop/lib/* "$out"/lib

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
  outputs = [ "out" "doc" ];

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
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software HD-audio player";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
