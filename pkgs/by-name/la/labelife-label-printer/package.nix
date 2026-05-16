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
  version = "2.2.0.002";

  arch =
    archAttrset.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://oss.qu-in.ltd/Labelife/Label_Printer_Driver_Linux.zip";
    hash = "sha256-yUrEV3pdTqiATZ1V9Ze0zTjsyA3b9i+Bbh1v0FzGeas=";
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
    tar -xzf Label_Printer_Driver_Linux.tar.gz --strip-components=1

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
      Supported printer models include:
      - D520 & D520BT
      - PM-241 & PM-241-BT

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
