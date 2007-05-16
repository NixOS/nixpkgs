{stdenv, fetchurl, curl, openssl, zlib, expat, perl}:

stdenv.mkDerivation {
  name = "git-1.5.1.2";

  src = fetchurl {
    url = http://www.kernel.org/pub/software/scm/git/git-1.5.1.2.tar.bz2;
    sha256 = "0a7nnw9631h6nxk7sny0cjv89qlibilvsm6947620vr2kgc6p6k2";
  };

  buildInputs = [curl openssl zlib expat];

  preBuild = "
    makeFlagsArray=(prefix=$out PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}/bin/sh)
  ";
}
