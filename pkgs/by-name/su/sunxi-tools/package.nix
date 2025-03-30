{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dtc,
  libusb1,
  zlib,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "sunxi-tools";
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "4390ca668f3b2e62f885edb6952b189c4489d83d";
    sha256 = "sha256-TwMV+hsbfARrns1ZimYTXNdGS8E9gIal6NqXBzsQjAc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dtc
    libusb1
    zlib
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [
    "tools"
    "misc"
  ];

  installTargets = [
    "install-tools"
    "install-misc"
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Tools for Allwinner SoC devices";
    homepage = "http://linux-sunxi.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.elitak ];
  };
}
