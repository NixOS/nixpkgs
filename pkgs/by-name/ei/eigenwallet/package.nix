{
  lib,
  fetchurl,
  stdenv,
  dpkg,
  autoPatchelfHook,
  cairo,
  gdk-pixbuf,
  webkitgtk_4_1,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "eigenwallet";
  version = "3.1.3";

  src = fetchurl {
    url = "https://github.com/eigenwallet/core/releases/download/${finalAttrs.version}/eigenwallet_${finalAttrs.version}_amd64.deb";
    hash = "sha256-HQqkoyzKqy4eaCfEwwkRUjgex834kkt2OR3Ib16bE0Y=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    webkitgtk_4_1
    gtk3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv {usr/bin,usr/share} $out

    runHook postInstall
  '';

  meta = {
    description = "Protocol and desktop application for swapping Monero and Bitcoin";
    homepage = "https://eigenwallet.org";
    maintainers = with lib.maintainers; [ JacoMalan1 ];
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "unstoppableswap-gui-rs";
  };
})
