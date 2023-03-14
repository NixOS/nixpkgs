{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, dpkg
, alsa-lib
, curl
, avahi
, gstreamer
, gst-plugins-base
, libxcb
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, libXrender
, libXxf86vm
, libglvnd
, gnome
}:

let
  runLibDeps = [
    curl
    avahi
    libxcb
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    libXxf86vm
    libglvnd
  ];

  runBinDeps = [
    gnome.zenity
  ];
in

stdenv.mkDerivation rec {
  pname = "kodelife";
  version = "1.0.6.163";

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.deb";
    hash = {
      aarch64-linux = "sha256-BbNk/YfTx/J8ApgdiY/thnD2MFUUCSQt/CMjkewLcL0=";
      armv7l-linux  = "sha256-fp4YM2BgyTr4vvxw5FaqKyGm608q8fOpB3gAgPA9UQ4=";
      x86_64-linux  = "sha256-sLRdU/UW2JORAUOPzmr+VUkcLoesrshjdLvDCizX0iM=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  unpackCmd = "mkdir root; dpkg-deb -x $curSrc root";

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    gstreamer
    gst-plugins-base
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/share

    mkdir -p $out/bin
    cp opt/kodelife/KodeLife $out/bin/KodeLife

    wrapProgram $out/bin/KodeLife \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runLibDeps} \
      --prefix PATH : ${lib.makeBinPath runBinDeps}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://hexler.net/kodelife";
    description = "Real-time GPU shader editor";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak lilyinstarlight ];
    platforms = [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ];
    mainProgram = "KodeLife";
  };
}
