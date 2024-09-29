{
  lib,
  stdenv,
  fetchurl,
  fuse,
  ncurses,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbde";
  version = "20221031";

  src = fetchurl {
    url = "https://github.com/libyal/libbde/releases/download/${finalAttrs.version}/libbde-alpha-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-uMbwofboePCFWlxEOdRbZK7uZuj0MZC/qusWuu0Bm7g=";
  };

  buildInputs = [
    fuse
    ncurses
    python3
  ];

  configureFlags = [ "--enable-python" ];

  meta = {
    description = "Library to access the BitLocker Drive Encryption (BDE) format";
    homepage = "https://github.com/libyal/libbde/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ eliasp ];
    platforms = lib.platforms.all;
  };
})
