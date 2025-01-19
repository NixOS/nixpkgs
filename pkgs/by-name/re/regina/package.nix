{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "regina-rexx";
  version = "3.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/regina-rexx/regina-rexx/${version}/regina-rexx-${version}.tar.gz";
    hash = "sha256-7ZjHp/HVpBSLAv7xsWruSmpthljQGoDPXFAwFe8Br6U=";
  };

  buildInputs = [ ncurses ];

  configureFlags = [
    "--libdir=$(out)/lib"
  ];

  meta = {
    description = "REXX interpreter";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
}
