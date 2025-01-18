{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.390";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    hash = "sha256-DexmtBKe1rrmvHMVk8P20hBLfdP1x6CWx/F1s4lDnK4=";
  };

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  meta = with lib; {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pedrohlc ];
    platforms = platforms.all;
  };
}
