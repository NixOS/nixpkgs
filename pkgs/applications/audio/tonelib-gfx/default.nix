{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, alsa-lib
, freetype
, libglvnd
, curl
, libXcursor
, libXinerama
, libXrandr
, libXrender
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "tonelib-gfx";
  version = "4.7.8";

  src = fetchurl {
    url = "https://tonelib.net/download/221222/ToneLib-GFX-amd64.deb";
    hash = "sha256-1sTwHqQYqNloZ3XSwhryqlW7b1FHh4ymtj3rKUcVZIo=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    freetype
    libglvnd
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
    substituteInPlace $out/share/applications/ToneLib-GFX.desktop --replace /usr/ $out/
 '';

  meta = with lib; {
    description = "Tonelib GFX is an amp and effects modeling software for electric guitar and bass.";
    homepage = "https://tonelib.net/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 orivej ];
    platforms = [ "x86_64-linux" ];
  };
}
