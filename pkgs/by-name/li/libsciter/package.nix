{
  lib,
  glib,
  cairo,
  libuuid,
  pango,
  gtk3,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "libsciter";
  version = "4.4.8.23-bis"; # Version specified in GitHub commit title

  src = fetchurl {
    url = "https://github.com/c-smile/sciter-sdk/raw/9f1724a45f5a53c4d513b02ed01cdbdab08fa0e5/bin.lnx/x64/libsciter-gtk.so";
    sha256 = "a1682fbf55e004f1862d6ace31b5220121d20906bdbf308d0a9237b451e4db86";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    cairo
    libuuid
    pango
    gtk3
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m755 -D $src $out/lib/libsciter-gtk.so

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://sciter.com";
    description = "Embeddable HTML/CSS/JavaScript engine for modern UI development";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ leixb ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
