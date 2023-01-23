{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, webkitgtk
, gtk3
, gdk-pixbuf
, cairo
, glib
, openssl
, clash
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    sha256 = "sha256-ZUjd1aK4PLZm3ieQnYNulgVdAB1d6GchKOy6iQWgzz0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  buildInputs = [
    webkitgtk
    gtk3
    gdk-pixbuf
    cairo
    glib
    openssl
  ];

  unpackCmd = "dpkg -x $src source";

  installPhase = ''
    mv usr $out
    rm $out/bin/clash
    wrapProgram $out/bin/clash-verge \
      --prefix PATH : ${lib.makeBinPath [ clash ]} \
  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri";
    maintainers = with maintainers; [ candyc1oud ];
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
