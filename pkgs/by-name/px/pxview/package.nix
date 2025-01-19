{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  perl,
  perlPackages,
  pxlib,
}:

stdenv.mkDerivation rec {
  pname = "pxview";
  version = "0.2.5";
  src = fetchurl {
    url = "mirror://sourceforge/pxlib/${pname}_${version}.orig.tar.gz";
    sha256 = "1kpdqs6lvnyj02v9fbz1s427yqhgrxp7zw63rzfgiwd4iqp75139";
  };

  buildInputs = [
    pxlib
    perl
  ] ++ (with perlPackages; [ libxml_perl ]);
  nativeBuildInputs = [ pkg-config ];

  configureFlags = [ "--with-pxlib=${pxlib.out}" ];

  # https://sourceforge.net/p/pxlib/bugs/12/
  LDFLAGS = "-lm";
  hardeningDisable = [ "format" ];

  meta = {
    description = "Program to convert Paradox databases";
    mainProgram = "pxview";
    homepage = "https://pxlib.sourceforge.net/pxview/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.winpat ];
  };
}
