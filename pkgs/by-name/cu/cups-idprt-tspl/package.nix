{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
  cups,
  e2fsprogs,
  krb5,
  libxcrypt-legacy,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-tspl";
  version = "1.4.7";

  src = fetchurl {
    name = "idprt_tspl_printer_linux_driver.zip"; # This is not the original name, but there was debate about whether rec or finalAttrs should be used, so I just renamed it
    url = "https://www.idprt.com/prt_v2/files/down_file/id/283/fid/668.html"; # NOTE: This is NOT an HTML page, but a ZIP file
    hash = "sha256-P3AKSqCh5onOv0itJayEJ6P5pmlkOwOh1OtUjg40BRw=";
  };

  buildInputs = [
    cups
    e2fsprogs
    krb5
    libxcrypt-legacy
  ];
  nativeBuildInputs = [
    autoPatchelfHook
    unzip
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
      rm $out/share/cups/model/*.ppd~
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
