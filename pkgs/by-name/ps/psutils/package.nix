{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "psutils";
  version = "17";

  src = fetchurl {
    url = "http://knackered.knackered.org/angus/download/${pname}/${pname}-p${version}.tar.gz";
    hash = "sha256-OFPreVhLqPvieoFUJbZan38Vsljg1DoFqFa9t11YiuQ=";
  };

  postPatch = ''
    sed -i 's/void main/int main/' *.c
  '';

  configurePhase = ''
    sed -e 's,/usr/local/bin/perl,${perl}/bin/perl,' \
      -e "s,/usr/local,$out," \
      -e "s,CFLAGS =,CFLAGS = -std=c89," \
      Makefile.unix > Makefile
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = {
    description = "Collection of useful utilities for manipulating PS documents";
    homepage = "http://knackered.knackered.org/angus/psutils/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
