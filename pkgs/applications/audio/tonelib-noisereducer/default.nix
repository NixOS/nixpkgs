{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, alsa-lib
, freetype
, libglvnd
, mesa
, curl
, libXcursor
, libXinerama
, libXrandr
, libXrender
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "tonelib-noisereducer";
  version = "1.2.0";

  src = fetchurl {
    url = "https://tonelib.net/download/221222/ToneLib-NoiseReducer-amd64.deb";
    sha256 = "sha256-27JuFVmamIUUKRrpjlsE0E6x+5X9RutNGPiDf5dxitI=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    freetype
    libglvnd
    mesa
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
 '';

  meta = with lib; {
    description = "ToneLib NoiseReducer – two-unit noise reduction rack effect plugin";
    homepage = "https://tonelib.net/tl-noisereducer.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
  };
}
