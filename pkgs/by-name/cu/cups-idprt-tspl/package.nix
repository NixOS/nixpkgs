{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  cups,
  e2fsprogs,
  krb5,
  libxcrypt-legacy,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-tspl";
  version = "1.4.9";

  src = fetchzip {
    url = "https://foreverfile.hprtcloud.com/hygj/annex_file/2026_09_21/34fU8Zn99OEzcQhg/idprt_tspl_printer_linux_driver_v1.4.9.zip";
    hash = "sha256-OYwsXnJsDBlHUllDhqBMC9a8Q1uKeuWirlS+DJpPtM4=";
  };

  buildInputs = [
    cups
    e2fsprogs
    krb5
    libxcrypt-legacy
  ];
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
          or (throw "cups-idprt-tspl: No prebuilt filters for system: ${stdenvNoCC.hostPlatform.system}");
    in
    ''
      runHook preInstall
      mkdir -p $out/share/cups/model $out/lib/cups/filter
      cp -r filter/${arch}/. $out/lib/cups/filter
      cp -r ppd/. $out/share/cups/model
      find $out/share/cups/model -name '*.ppd~' -delete
      chmod +x $out/lib/cups/filter/*
      runHook postInstall
    '';

  meta = {
    description = "CUPS drivers for TSPL-based iDPRT thermal label printers (SP210, SP310, SP320, SP320E, SP410, SP410BT, SP420, SP450, SP460BT)";
    platforms = [
      "x86_64-linux"
      "x86-linux"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
