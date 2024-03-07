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
  pname = "tonelib-metal";
  version = "1.2.6";

  src = fetchurl {
    url = "https://tonelib.net/download/221222/ToneLib-Metal-amd64.deb";
    sha256 = "sha256-G80EKAsXomdk8GsnNyvjN8shz3YMKhqdWWYyVB7xTsU=";
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
    substituteInPlace $out/share/applications/ToneLib-Metal.desktop --replace /usr/ $out/
 '';

  meta = with lib; {
    description = "ToneLib Metal – Guitar amp simulator targeted at metal players";
    homepage = "https://tonelib.net/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
  };
}
