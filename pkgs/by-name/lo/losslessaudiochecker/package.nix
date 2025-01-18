{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "losslessaudiochecker";
  version = "2.0.5";

  src = fetchurl {
    url = "https://web.archive.org/web/20211119122205/https://losslessaudiochecker.com/dl/LAC-Linux-64bit.tar.gz";
    sha256 = "1i1zbl7sqwxwmhw89lgz922l5k85in3y76zb06h8j3zd0lb20wkq";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    install LAC -D -t $out/bin
  '';

  meta = with lib; {
    description = "Utility to check whether audio is truly lossless or not";
    homepage = "https://losslessaudiochecker.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ p-h ];
    mainProgram = "LAC";
  };
}
