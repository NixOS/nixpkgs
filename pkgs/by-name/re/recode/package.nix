{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
  perl,
  flex,
  texinfo,
  libiconv,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "recode";
  version = "3.7.16";

  # Use official tarball, avoid need to bootstrap/generate build system
  src = fetchurl {
    url = "https://github.com/rrthomas/recode/releases/download/v${finalAttrs.version}/recode-${finalAttrs.version}.tar.gz";
    hash = "sha256-w9QH9U90uudjYDEgluLtRmIvAchuULCe9Fstk8j8/y0=";
  };

  nativeBuildInputs = [
    python3Packages.python
    perl
    flex
    texinfo
    libiconv
  ];

  buildInputs = [ libintl ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = with python3Packages; [
    cython
    setuptools
  ];

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    mainProgram = "recode";
    changelog = "https://github.com/rrthomas/recode/raw/v${finalAttrs.version}/NEWS";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ jcumming ];
  };
})
