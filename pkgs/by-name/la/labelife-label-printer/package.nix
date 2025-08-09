{
  lib,
  stdenv,
  fetchzip,
  cups,
  autoPatchelfHook,
  detox,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labelife-label-printer";
  version = "2.0.0";

  arch =
    {
      aarch64-linux = "aarch64";
      armv7l-linux = "armhf";
      i686-linux = "i386";
      x86_64-linux = "x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchzip {
    url = "https://oss.qu-in.ltd/Labelife/Label_Printer_Driver_Linux.zip";
    hash = "sha256-0ESZ0EqPh9Wz6ogQ6vTsAogujbn4zINtMh62sEpNRs4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    detox
  ];
  buildInputs = [ cups ];

  unpackPhase = ''
    runHook preUnpack

    tar -xzf ${finalAttrs.src}/LabelPrinter-${finalAttrs.version}.001.tar.gz --strip-components=1

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    # Remove spaces from PPD filenames
    detox ppds

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
      - PM-241 & PM-241-BT

      Brands using Labelife drivers include:
      - Phomemo
      - Itari
      - Omezizy
      - Aimo
    '';
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
