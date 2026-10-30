{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  cups,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-mt890";
  version = "1.2.0";

  src = fetchzip {
    url = "https://foreverfile.hprtcloud.com/hygj/annex_file/2025_11_05/qNL2iNg5PuZCOHwK/idprt_mt890_printer_linux_driver_v1.2.0.zip";
    hash = "sha256-PiNbpfa9daD1gNE/4K4KbKXnLtJpyWKllc4z80USzSo=";
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
          or (throw "cups-idprt-mt890: No prebuilt filters for system: ${stdenvNoCC.hostPlatform.system}");
    in
    ''
      runHook preInstall
      mkdir -p $out/share/cups/model $out/lib/cups/filter
      cp -r filter/${arch}/. $out/lib/cups/filter
      cp -r ppd/. $out/share/cups/model
      rm $out/share/cups/model/*.ppd~
      chmod +x $out/lib/cups/filter/*
      runHook postInstall
    '';

  meta = {
    description = "CUPS driver for the iDPRT MT890";
    platforms = [
      "x86_64-linux"
      "x86-linux"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
