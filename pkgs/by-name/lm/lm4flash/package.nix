{
  fetchFromGitHub,
  stdenv,
  libusb1,
  pkg-config,
  lib,
  writeText,
}:
let
  stellaris-udev-rules = writeText "61.stellpad.rules" ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00fd", MODE="0666"
  '';
in
stdenv.mkDerivation rec {
  pname = "lm4flash";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "utzig";
    repo = "lm4tools";
    tag = "v${version}";
    hash = "sha256-ZjuCH/XjQEgg6KHAvb95/BkAy+C2OdbtBb/i6K30+uo=";
  };
  sourceRoot = "${src.name}/lm4flash";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  buildFlags = [ "release" ];

  installFlags = [ "PREFIX=$(out)" ];

  doInstallCheck = true;

  postInstall = ''
    install -Dm644 "${stellaris-udev-rules}" "$out/etc/udev/rules.d/61.stellpad.rules"
  '';

  meta = {
    description = "Command-line firmware flashing tool for the Stellaris Launchpad";
    longDescription = ''
      Command-line firmware flashing tool using libusb-1.0 to communicate with
      the Stellaris Launchpad ICDI. Works on all Linux, Mac OS X, Windows, and
      BSD systems.
    '';
    homepage = "https://github.com/utzig/lm4tools";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lm4flash";
    maintainers = with lib.maintainers; [ MostafaKhaled ];
    platforms = lib.platforms.all;
  };
}
