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
  pname = "eigenwallet";
  version = "3.3.7";

  src = fetchurl {
    url = "https://github.com/eigenwallet/core/releases/download/${finalAttrs.version}/eigenwallet_${finalAttrs.version}_amd64.deb";
    hash = "sha256-F0EzdEG9/+LzINOL59wgYSvvzeTC0im8hB8UZxEphZM=";
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
