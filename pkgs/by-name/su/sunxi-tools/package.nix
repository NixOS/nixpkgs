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
  version = "0-unstable-2026-11-05";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "34dfa20f8284273085666436e4cac09af19646c8";
    sha256 = "sha256-HlJ4ApOUnaA8TxDta8Y8qkPCw+cXLJYp4niAPG/a7FA=";
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
}
