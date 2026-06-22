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
  version = "0-unstable-2026-06-08";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "d7bbd172a5da601a08f94479de308c6fb714a19a";
    sha256 = "sha256-QOW9uzECcxu2t+5lrIjC0zwNUuRvaipy5+kFBxIqwjg=";
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
