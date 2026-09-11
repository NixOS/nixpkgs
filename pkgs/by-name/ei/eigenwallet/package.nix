{
  lib,
  fetchurl,
  stdenv,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  cairo,
  gdk-pixbuf,
  webkitgtk_4_1,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigenwallet";
  version = "4.13.3";

  src = fetchurl {
    url = "https://github.com/eigenwallet/core/releases/download/${finalAttrs.version}/eigenwallet_${finalAttrs.version}_amd64.deb";
    hash = "sha256-nVrl3XY6fN8lA/RUL2P/NzMaOdPUIFxsEYbROk7keTA=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
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
