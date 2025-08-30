{
  lib,
  stdenv,
  fetchurl,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "probe-rs-udev-rules";
  version = "1.0.0";

  src = fetchurl {
    url = "https://probe.rs/files/69-probe-rs.rules";
    hash = "sha256-yjxld5ebm2jpfyzkw+vngBfHu5Nfh2ioLUKQQDY4KYo=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -D -m 644 $src $out/lib/udev/rules.d/69-probe-rs.rules

    runHook postInstall
  '';

  meta = with lib; {
    description = "Udev rules for probe-rs debugging probes";
    longDescription = ''
      This package provides official udev rules for debugging probes used with
      probe-rs, including ST-LINK, SEGGER J-Link, FTDI-based devices,
      Espressif USB JTAG, CMSIS-DAP compatible adapters, and WCH Link adapters.

      The rules use TAG+="uaccess" to grant access to locally logged-in users
      via systemd-logind, eliminating the need for manual group configuration.
    '';
    homepage = "https://probe.rs/docs/getting-started/probe-setup/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wvhulle ];
  };
}
