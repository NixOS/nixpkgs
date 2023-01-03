{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, dpkg
, alsa-lib
, curl
, avahi
, jack2
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
    jack2
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
  pname = "touchosc";
  version = "1.1.6.150";

  suffix = {
    aarch64-linux = "linux-arm64";
    armv7l-linux  = "linux-armhf";
    x86_64-linux  = "linux-x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.deb";
    hash = {
      aarch64-linux = "sha256-sYkAFyXnmzgSzo68OF0oiv8tUvY+g1WCcY783OZO+RM=";
      armv7l-linux  = "sha256-GWpYW1262plxIzPVzBEh4Z3fQIhSmy0N9xAgwnjXrQE=";
      x86_64-linux  = "sha256-LUWlLEsTUqVoWAkjXC/zOziPqO85H8iIlwJU7eqLRcY=";
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
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/share

    mkdir -p $out/bin
    cp opt/touchosc/TouchOSC $out/bin/TouchOSC

    wrapProgram $out/bin/TouchOSC \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runLibDeps} \
      --prefix PATH : ${lib.makeBinPath runBinDeps}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://hexler.net/touchosc";
    description = "Next generation modular control surface";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ];
    mainProgram = "TouchOSC";
  };
}
