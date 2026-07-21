{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cups,
  autoPatchelfHook,
}:

let
  archAttrset = {
    aarch64-linux = "aarch64";
    armv6l-linux = "arm";
    armv7l-linux = "armhf";
    i686-linux = "i386";
    x86_64-linux = "x86_64";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "labelife-label-printer";
  version = "2.3.1.001";

  arch =
    archAttrset.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://web.archive.org/web/20260607010653/https://oss.qu-in.ltd/Labelife/Label_Printer_Driver_Linux.zip";
    hash = "sha256-qpsyOuTrOTcXEQeCNNRV0QeV0s0RD2eqy/tGTA7qMWA=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];
  buildInputs = [ cups ];

  unpackPhase = ''
    runHook preUnpack

    # Extract outer ZIP file
    unzip -q ${finalAttrs.src}

    # Extract inner tar.gz with --strip-components=1 to remove the `LabelPrinter-${finalAttrs.version}/` prefix
    tar -xzf LabelPrinter-${finalAttrs.version}.tar.gz --strip-components=1

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # Install the CUPS filter with executable permissions
    install -Dm755 ./${finalAttrs.arch}/rastertolabeltspl $out/lib/cups/filter/rastertolabeltspl

    # Install all PPD files with read and write permissions for owner, and read for group and others
    for ppd in ./ppds/*.ppd; do
      install -Dm644 "$ppd" "$out/share/cups/model/label/$(basename "$ppd")"
    done
    runHook postInstall
  '';

  meta = {
    description = "CUPS driver for several Labelife-compatible thermal label printers";
    downloadPage = "https://labelife.net/#/chart";
    homepage = "https://labelife.net";
    license = lib.licenses.unfree;
    longDescription = ''
      CUPS driver for Labelife-compatible thermal label printers.
      Supported printer families include D-series (D420D, D520, D530,
      D550), PM-series (PM-241, PM-246S, PM-249, PM-344), T-series
      (T200, T300, T410, T460, T800), CT-series (CT200, CT310, CT510),
      AM-series (AM-242, AM-243), and others (A646, PL70, DS-50P, 6XL).

      Many models are available in multiple connectivity variants
      (BT, WF, WIFI).

      Brands using Labelife drivers include:
      - Phomemo
      - Itari
      - Omezizy
      - Aimo
    '';
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = lib.attrNames archAttrset;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
