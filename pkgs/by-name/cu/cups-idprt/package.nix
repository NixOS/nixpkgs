{ stdenvNoCC
, lib
, fetchurl
, autoPatchelfHook
, cups
, unzip
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt";
  version = "1.4.2";

  src = fetchurl {
    name = "idprt_tspl_printer_linux_driver.zip"; # This is not the original name, but there was debate about whether rec or finalAttrs should be used, so I just renamed it
    url = "https://www.idprt.com/prt_v2/files/down_file/id/131/fid/431.html"; # NOTE: This is NOT an HTML page, but a ZIP file
    hash = "sha256-xY5E1RUNQwK0BO+0JMT7oHCAvSe79t7UU65IOzRQs/Q=";
  };

  buildInputs = [
    cups
  ];
  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  installPhase = let
    arch = builtins.getAttr stdenvNoCC.hostPlatform.system {
      x86_64-linux = "x64";
      x86-linux = "x86";
    };
  in ''
    runHook preInstall
    mkdir -p $out/share/cups/model $out/lib/cups/filter
    cp -r filter/${arch}/. $out/lib/cups/filter
    cp -r ppd/. $out/share/cups/model
    chmod +x $out/lib/cups/filter/*
    runHook postInstall
  '';

  meta = with lib; {
    description = "CUPS Linux drivers for IDPRT thermal printers";
    platforms = [ "x86_64-linux" "x86-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ pandapip1 ];
  };
}
