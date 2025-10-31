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

let
  inherit (stdenv.targetPlatform) system;

  src.x86_64-linux = {
    urlPath = "x64";
    sha256 = "a1682fbf55e004f1862d6ace31b5220121d20906bdbf308d0a9237b451e4db86";
  };

  src.aarch64-linux = {
    urlPath = "arm64";
    sha256 = "sha256-bqGPbvtOM8/A6acDbFJGGf4kzKo/4S/bWcH/XvxVySU=";
  };

in

stdenv.mkDerivation {
  pname = "libsciter";
  version = "4.4.8.23-bis"; # Version specified in GitHub commit title

  src = fetchurl {
    url = "https://github.com/c-smile/sciter-sdk/raw/524a90ef7eab16575df9496f7e4c374bbd5fb1fe/bin.lnx/${src.${system}.urlPath}/libsciter-gtk.so";
    inherit (src.${system}) sha256;
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ leixb ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
