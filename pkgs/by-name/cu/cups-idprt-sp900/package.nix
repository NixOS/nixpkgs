{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  cups,
  cups-idprt-update-script,
  e2fsprogs,
  krb5,
  libxcrypt-legacy,
}:

stdenvNoCC.mkDerivation {
  pname = "cups-idprt-sp900";
  version = "1.4.0";

  src = fetchzip {
    url = "https://foreverfile.hprtcloud.com/hygj/annex_file/2025_11_05/ItLVsNAMOmZ33ZKy/idprt_sp900_printer_linux_driver_v1.4.0.tar.gz";
    hash = "sha256-FcRjjtqEdbZeno7fjiY9XQhLJgOfHrwnXU1D+u28M4o=";
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
          or (throw "cups-idprt-sp900: No prebuilt filters for system: ${stdenvNoCC.hostPlatform.system}");
    in
    ''
      runHook preInstall
      mkdir -p $out/share/cups/model $out/lib/cups/filter
      cp -r filter/${arch}/. $out/lib/cups/filter
      cp -r ppd/. $out/share/cups/model
      chmod +x $out/lib/cups/filter/*
      runHook postInstall
    '';

  passthru.updateScript = [
    (lib.getExe cups-idprt-update-script)
    "SP900"
  ];

  meta = {
    description = "CUPS driver for the iDPRT SP900";
    platforms = [
      "x86_64-linux"
      "x86-linux"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
