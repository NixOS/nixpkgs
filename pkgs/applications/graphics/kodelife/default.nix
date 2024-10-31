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
, zenity
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
    zenity
  ];
in

stdenv.mkDerivation rec {
  pname = "kodelife";
  version = "1.1.0.173";

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
    x86_64-linux  = "linux-x64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.deb";
    hash = {
      aarch64-linux = "sha256-WPUWvgVZR+2Dg4zpk+iUemMBGlGBDtaGkUGrWuF5LBs=";
      armv7l-linux  = "sha256-tOPqP40e0JrXg92OluMZrurWHXZavGwTkJiNN1IFVEE=";
      x86_64-linux  = "sha256-ZA8BlUtKaiSnXGncYwb2BbhBlULuGz7SWuXL0RAgQLI=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

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
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ];
    mainProgram = "KodeLife";
  };
}
