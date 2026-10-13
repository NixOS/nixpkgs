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
  version = "0-unstable-2026-10-11";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "bc96c0ae5d97b15e482404665b4218fcbcf11db7";
    sha256 = "sha256-+getchEatoFa3Oy9reS1pSk9UasMb76SGyAPxkUhTEs=";
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
    maintainers = [ ];
  };
}
