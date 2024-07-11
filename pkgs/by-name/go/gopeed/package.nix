{ lib
, fetchurl
, stdenv
, autoPatchelfHook
, dpkg
, makeWrapper
, at-spi2-atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, harfbuzz
, libayatana-appindicator
, libayatana-indicator
, libdbusmenu
, pango
, zenity
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.5.7";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-VIRxn+iHkJSzlX/RB4DsCHgB4+pGM3rJ2SE5ZAJwGwE=";
  };

  dontConfigure = true;

  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
    at-spi2-atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libayatana-appindicator
    libayatana-indicator
    libdbusmenu
    pango
    zenity
  ];

  unpackPhase = ''
    runHook preUnpack

      dpkg-deb -x ${src} ./

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    mv usr/* opt -t $out

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    makeWrapper $out/opt/gopeed/gopeed $out/bin/gopeed \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
    runHook postFixup
  '';

  meta = {
    homepage = "https://gopeed.com/";
    description = "Modern download manager that supports all platforms, built with Golang and Flutter";
    longDescription = ''
      Gopeed (full name Go Speed), a high-speed download manager, supports (HTTP, BitTorrent, Magnet) protocol,
      and supports all platforms. It is also a highly customizable that supports implementing more features through
      integration with APIs or installation and development of extensions.
    '';
    maintainers = with lib.maintainers; [ ByteSudoer ];
    license = with lib.licenses; [ gpl3Only ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gopeed";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
