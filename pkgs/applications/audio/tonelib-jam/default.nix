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
}:

stdenv.mkDerivation rec {
  pname = "tonelib-jam";
  version = "4.7.8";

  src = fetchurl {
    url = "https://tonelib.net/download/221222/ToneLib-Jam-amd64.deb";
    sha256 = "sha256-c6At2lRPngQPpE7O+VY/Hsfw+QfIb3COIuHfbqqIEuM=";
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-Jam";
  };
}
