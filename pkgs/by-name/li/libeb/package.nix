{
  lib,
  stdenv,
  fetchurl,
  perl,
  zlib,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libeb";
  version = "4.4.3";

  src = fetchurl {
    url = "ftp://ftp.sra.co.jp/pub/misc/eb/eb-${finalAttrs.version}.tar.bz2";
    sha256 = "0psbdzirazfnn02hp3gsx7xxss9f1brv4ywp6a15ihvggjki1rxb";
  };

  patches = [
    (fetchpatch {
      name = "gcc-14.patch";
      url = "https://salsa.debian.org/debian/eb/-/raw/7f4f013678f307efaa463b187e0ecd643df1d0ba/debian/patches/0002-gcc14-fix.patch";
      hash = "sha256-0hht7ojj4MLNfFbemDR2hD1PbSmBxrC2JtDl2WJINlM=";
    })
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://salsa.debian.org/debian/eb/-/raw/7f4f013678f307efaa463b187e0ecd643df1d0ba/debian/patches/0003-gcc15-fix.patch";
      hash = "sha256-2Q54Xy6I9NrHtXQeNmcR+r71KnRsXDma1GIk9qSOP1g=";
    })
  ];

  nativeBuildInputs = [ perl ];
  buildInputs = [ zlib ];

  meta = {
    description = "C library for accessing Japanese CD-ROM books";
    longDescription = ''
      The EB library is a library for accessing CD-ROM books, which are a
      common way to distribute electronic dictionaries in Japan.  It supports
      the EB, EBG, EBXA, EBXA-C, S-EBXA and EPWING formats.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
