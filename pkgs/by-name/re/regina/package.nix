{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "regina-rexx";
  version = "3.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/regina-rexx/regina-rexx/${version}/regina-rexx-${version}.tar.gz";
    hash = "sha256-8TcB69VC500PyDsqeHaoErB9IeQ0ACde1lsayGAgS9Q=";
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
