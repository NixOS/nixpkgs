{ stdenv, fetchurl, emacs, gmp, pcre, expat }:

stdenv.mkDerivation rec {
  name = "ledger2-2.6.3";

  src = fetchurl {
    url = "https://github.com/downloads/ledger/ledger/${name}.tar.gz";
    sha256 = "05zpnypcwgck7lwk00pbdlcwa347xsqifxh4zsbbn01m98bx1v5k";
  };

  buildInputs = [ emacs gmp pcre expat ];

  configureFlags = [
    "CPPFLAGS=-DNDEBUG"
    "CFLAGS=-O3"
    "CXXFLAGS=-O3"
  ];

  doCheck = true;

  # Patchelf breaks the hard-coded rpath to ledger's libamounts.0.so and
  # libledger-2.6.3.so. Fortunately, libtool chooses proper rpaths to
  # begin with, so we can just disable patchelf to avoid the issue.
  dontPatchELF = true;

  meta = {
    homepage = https://ledger-cli.org/;
    description = "A double-entry accounting system with a command-line reporting interface";
    license = "BSD";

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = stdenv.lib.platforms.all;
    broken = true; # https://hydra.nixos.org/build/59124559/nixlog/1
  };
}
