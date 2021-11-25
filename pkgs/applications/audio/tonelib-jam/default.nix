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
  pname = "tonelib-jam";
  version = "4.7.0";

  src = fetchurl {
    url = "https://www.tonelib.net/download/0930/ToneLib-Jam-amd64.deb";
    sha256 = "sha256-xyBDp3DQVC+nK2WGnvrfUfD+9GvwtbldXgExTMmCGw0=";
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
    substituteInPlace $out/share/applications/ToneLib-Jam.desktop --replace /usr/ $out/
  '';

  meta = with lib; {
    description = "ToneLib Jam – the learning and practice software for guitar players";
    homepage = "https://tonelib.net/";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
  };
}
