{ stdenv, fetchurl, writeShellScriptBin }:

stdenv.mkDerivation rec {
  name    = "boolector-${version}";
  version = "2.4.1";
  src = fetchurl {
    url    = "http://fmv.jku.at/boolector/boolector-${version}-with-lingeling-bbc.tar.bz2";
    sha256 = "0mdf7hwix237pvknvrpazcx6s3ininj5k7vhysqjqgxa7lxgq045";
  };

  prePatch =
    let
      lingelingPatch = writeShellScriptBin "lingeling-patch" ''
        sed -i -e "1i#include <stdint.h>" lingeling/lglib.h

        ${crossFix}/bin/crossFix lingeling
      '';
      crossFix = writeShellScriptBin "crossFix" ''
        # substituteInPlace not available here
        sed -i $1/makefile.in \
          -e 's@ar rc@$(AR) rc@' \
          -e 's@ranlib@$(RANLIB)@'
      '';
    in ''
    sed -i -e 's@mv lingeling\* lingeling@\0 \&\& ${lingelingPatch}/bin/lingeling-patch@' makefile
    sed -i -e 's@mv boolector\* boolector@\0 \&\& ${crossFix}/bin/crossFix boolector@' makefile
  '';

  installPhase = ''
    mkdir $out
    mv boolector/bin $out
  '';

  meta = {
    license = stdenv.lib.licenses.unfreeRedistributable;
    description = "An extremely fast SMT solver for bit-vectors and arrays";
    homepage    = "http://fmv.jku.at/boolector";
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
