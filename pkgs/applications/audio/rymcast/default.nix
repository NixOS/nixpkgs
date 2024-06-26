{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  curl,
  gtk3,
  webkitgtk,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "rymcast";
  version = "1.0.6";

  src = fetchzip {
    url = "https://www.inphonik.com/files/rymcast/rymcast-${version}-linux-x64.tar.gz";
    hash = "sha256:0vjjhfrwdibjjgz3awbg30qxkjrzc4cya1f4pigwjh3r0vvrq0ga";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    curl
    gtk3
    stdenv.cc.cc.lib
    webkitgtk
    zenity
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp RYMCast "$out/bin/"
    wrapProgram "$out/bin/RYMCast" \
      --set PATH "${lib.makeBinPath [ zenity ]}"
  '';

  meta = with lib; {
    description = "Player for Mega Drive/Genesis VGM files";
    homepage = "https://www.inphonik.com/products/rymcast-genesis-vgm-player/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ astsmtl ];
  };
}
