{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  cups,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-barcode";
  version = "1.2.21";

  src = fetchzip {
    url = "https://foreverfile.hprtcloud.com/hygj/annex_file/2026_08_03/vzMD7D5IeyIYh979/idprt_label_printer_linux_driver_v1.2.21.zip";
    hash = "sha256-HFEbVvCOzTeDEeWiBJ6+rmchirHMFxgPOV7U0NSSVLI=";
  };

  buildInputs = [ cups ];
  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase =
    let
      arch =
        {
          x86_64-linux = "x64";
          x86-linux = "x86";
        }
        ."${stdenvNoCC.hostPlatform.system}"
          or (throw "cups-idprt-barcode: No prebuilt filters for system: ${stdenvNoCC.hostPlatform.system}");
    in
    ''
      runHook preInstall
      mkdir -p $out/share/cups/model $out/lib/cups/filter
      cp -r filter/${arch}/. $out/lib/cups/filter
      cp -r ppd/. $out/share/cups/model
      chmod +x $out/lib/cups/filter/*
      runHook postInstall
    '';

  meta = {
    description = "CUPS drivers for iDPRT barcode printers (iD2P, iD2X, iD4P, iD4S, iE2P, iE2X, iE4P, iE4S, iT4B, iT4E, iT4P, iT4S, iT4X, iX4E, iX4L, iX4P, iX4E, iX6P)";
    platforms = [
      "x86_64-linux"
      "x86-linux"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
