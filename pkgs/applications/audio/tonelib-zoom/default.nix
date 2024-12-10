{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  freetype,
  libglvnd,
  curl,
  libXcursor,
  libXinerama,
  libXrandr,
  libXrender,
  libjack2,
  webkitgtk,
}:

stdenv.mkDerivation rec {
  pname = "tonelib-zoom";
  version = "4.3.1";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0129/ToneLib-Zoom-amd64.deb";
    sha256 = "sha256-4q2vM0/q7o/FracnO2xxnr27opqfVQoN7fsqTD9Tr/c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    freetype
    libglvnd
    webkitgtk
  ] ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    curl
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libjack2
  ];

  unpackCmd = "dpkg -x $curSrc source";

  installPhase = ''
    mv usr $out
    substituteInPlace $out/share/applications/ToneLib-Zoom.desktop --replace /usr/ $out/
  '';

  meta = with lib; {
    description = "ToneLib Zoom – change and save all the settings in your Zoom(r) guitar pedal";
    homepage = "https://tonelib.net/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-Zoom";
  };
}
