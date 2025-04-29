{
  lib,
  stdenv,
  fetchurl,
  cups,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labelife-label-printer";
  version = "1.2.1";

  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x86_64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "i386"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  src = fetchurl {
    url = "https://oss.saas.aimocloud.com/saas/Lablife/bag/LabelPrinter-${finalAttrs.version}.tar.gz";
    hash = "sha256-twnIFMBMyEM3xGlsuk3763C3emz3mgpEnlfvnL0XRWw=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ cups ];

  installPhase = ''
    runHook preInstall
    # Install the CUPS filter with executable permissions
    install -Dm755 ./${finalAttrs.arch}/rastertolabeltspl $out/lib/cups/filter/rastertolabeltspl

    # Install all PPD files with read and write permissions for owner, and read for group and others
    for ppd in ./ppds/*.ppd; do
      install -Dm644 $ppd $out/share/cups/model/label/$(basename $ppd)
    done
    runHook postInstall
  '';

  meta = {
    description = "CUPS driver for several Labelife-compatible thermal label printers";
    downloadPage = "https://labelife.net/#/chart";
    homepage = "https://labelife.net";
    license = lib.licenses.unfree;
    longDescription = ''
      Supported printer models include:
      - D520 & D520BT
      - PM-201
      - PM-241 & PM-241-BT
      - PM-246 & PM-246S

      Brands using Labelife drivers include:
      - Phomemo
      - Itari
      - Omezizy
      - Aimo
    '';
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
