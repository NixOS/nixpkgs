{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  gtk3-x11,
}:

stdenv.mkDerivation rec {
  pname = "pixeluvo";
  version = "1.6.0-2";

  src = fetchurl {
    url = "http://www.pixeluvo.com/downloads/${pname}_${version}_amd64.deb";
    sha256 = "sha256-QYSuD6o3kHg0DrFihYEcf9e3b8U1bu4Zf78+Akmm8yo=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3-x11
    stdenv.cc.cc
  ];

  libPath = lib.makeLibraryPath buildInputs;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out
    install -Dm644 $out/opt/pixeluvo/pixeluvo.png -t $out/share/pixmaps/

    substituteInPlace $out/share/applications/pixeluvo.desktop \
      --replace '/opt/pixeluvo/pixeluvo.png' pixeluvo

    makeWrapper $out/opt/pixeluvo/bin/Pixeluvo64 $out/bin/pixeluvo \
      --prefix LD_LIBRARY_PATH : ${libPath}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Beautifully Designed Image and Photo Editor for Windows and Linux";
    homepage = "http://www.pixeluvo.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    mainProgram = "pixeluvo";
  };
}
