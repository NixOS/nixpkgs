{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "rman";
  version = "3.2";

  src = fetchurl {
    url = "mirror://sourceforge/polyglotman/${version}/${pname}-${version}.tar.gz";
    sha256 = "0prdld6nbkdlkcgc2r1zp13h2fh8r0mlwxx423dnc695ddlk18b8";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace ginstall install \
      --replace gcc '${stdenv.cc.targetPrefix}cc'
  '';

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man
  '';

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  doCheck = false; # "check" target is probably meant to do "installcheck" or something

  meta = {
    description = "Parse formatted man pages and man page source from most flavors of UNIX and converts them to HTML, ASCII, TkMan, DocBook, and other formats";
    license = lib.licenses.artistic1;
    platforms = lib.platforms.all;
    mainProgram = "rman";
  };
}
