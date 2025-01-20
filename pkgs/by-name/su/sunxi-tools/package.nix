{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dtc,
  libusb1,
  zlib,
}:

stdenv.mkDerivation {
  pname = "sunxi-tools";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "29d48c3c39d74200fb35b5750f99d06a4886bf2e";
    sha256 = "sha256-IUgAM/wVHGbidJ2bfLcTIdXg7wxEjxCg1IA8FtDFpR4=";
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

  meta = with lib; {
    description = "Tools for Allwinner SoC devices";
    homepage = "http://linux-sunxi.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elitak ];
  };
}
