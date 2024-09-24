{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
  cups,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-mt890";
  version = "1.2.0";

  src = fetchurl {
    name = "idprt_mt890_printer_linux_driver.zip";
    url = "https://www.idprt.com/prt_v2/files/down_file/id/320/fid/778.html"; # NOTE: This is NOT an HTML page, but a ZIP file
    hash = "sha256-8yH+DSPRp4mjKOXw90TiGA4OzxJKHpBUMSLh3L2njw8=";
  };

  buildInputs = [ cups ];
  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  installPhase =
    let
      arch = builtins.getAttr stdenvNoCC.hostPlatform.system {
        x86_64-linux = "x64";
        x86-linux = "x86";
      };
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
