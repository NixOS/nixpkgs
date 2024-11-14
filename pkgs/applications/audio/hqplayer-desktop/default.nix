{ mkDerivation
, alsa-lib
, autoPatchelfHook
, evince
, fetchurl
, flac
, gcc12
, lib
, libmicrohttpd
, libusb-compat-0_1
, llvmPackages
, qtcharts
, qtdeclarative
, qtquickcontrols2
, qtwebengine
, qtwebview
, rpmextract
, wavpack
}:

mkDerivation rec {
  pname = "hqplayer-desktop";
  version = "4.22.0-65";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/hqplayer4desktop-${version}.fc36.x86_64.rpm";
    sha256 = "sha256-PA8amsqy4O9cMruNYVhG+uBiUGQ5WfnZC2ARppmZd7g=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract "$src"
  '';

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  buildInputs = [
    alsa-lib
    flac
    gcc12.cc.lib
    libmicrohttpd
    libusb-compat-0_1
    llvmPackages.openmp
    qtcharts
    qtdeclarative
    qtquickcontrols2
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
    mv ./opt/hqplayer4desktop/lib/* "$out"/lib

    # main executable
    mkdir -p "$out"/bin
    mv ./usr/bin/* "$out"/bin

    # documentation
    mkdir -p "$doc/share/doc/${pname}" "$doc/share/applications"
    mv ./usr/share/doc/hqplayer4desktop/* "$doc/share/doc/${pname}"
    mv ./usr/share/applications/hqplayer4desktop-manual.desktop "$doc/share/applications"

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
    for desktopFile in $out/share/applications/hqplayer4{desktop-nostyle,desktop-highdpi,-client,desktop}.desktop; do
      substituteInPlace "$desktopFile" \
        --replace /usr/bin "$out"/bin
    done
    substituteInPlace "$doc/share/applications/hqplayer4desktop-manual.desktop" \
        --replace /usr/share/doc/hqplayer4desktop "$doc/share/doc/${pname}" \
        --replace evince "${evince}/bin/evince"
  '';

  postFixup = ''
    patchelf --replace-needed libomp.so.5 libomp.so "$out/bin/.hqplayer4desktop-wrapped"
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software HD-audio player";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
