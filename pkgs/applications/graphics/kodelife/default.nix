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
<<<<<<< HEAD
  version = "1.1.0.173";
=======
  version = "1.0.8.170";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
<<<<<<< HEAD
    x86_64-linux  = "linux-x64";
=======
    x86_64-linux  = "linux-x86_64";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.deb";
    hash = {
<<<<<<< HEAD
      aarch64-linux = "sha256-WPUWvgVZR+2Dg4zpk+iUemMBGlGBDtaGkUGrWuF5LBs=";
      armv7l-linux  = "sha256-tOPqP40e0JrXg92OluMZrurWHXZavGwTkJiNN1IFVEE=";
      x86_64-linux  = "sha256-ZA8BlUtKaiSnXGncYwb2BbhBlULuGz7SWuXL0RAgQLI=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

=======
      aarch64-linux = "sha256-FHE87B34QSc7rcKHE3wkZq1VzcZeKWh68rlIIMDRmm8=";
      armv7l-linux  = "sha256-OqomlL7IFHyQQULbdbf5I0dRXdy3lDHY4ej2P1OZgzo=";
      x86_64-linux  = "sha256-QNcWMVZ4bTXPLFEtD35hP2LbuNntvF2e9Wk2knt4TBY=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  unpackCmd = "mkdir root; dpkg-deb -x $curSrc root";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
