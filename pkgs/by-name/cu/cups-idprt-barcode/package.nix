{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
  cups,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-barcode";
  version = "1.2.1";

  src = fetchurl {
    name = "idprt_label_printer_linux_driver.zip"; # This is not the original name, but there was debate about whether rec or finalAttrs should be used, so I just renamed it
    url = "https://www.idprt.com/prt_v2/files/down_file/id/265/fid/600.html"; # NOTE: This is NOT an HTML page, but a ZIP file
    hash = "sha256-jp8DDaTmCgNrHCJSSz1K3xDcSB8dQm6i1pICaMrBFaQ=";
  };

  buildInputs = [ cups ];
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
