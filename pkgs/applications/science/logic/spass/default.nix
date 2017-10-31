{ stdenv, fetchurl, bison, flex }:

let
  baseVersion="3";
  minorVersion="9";

  extraTools = "FLOTTER prolog2dfg dfg2otter dfg2dimacs dfg2tptp"
    + " dfg2ascii dfg2dfg tptp2dfg dimacs2dfg pgen rescmp";
in

stdenv.mkDerivation rec {
  name = "spass-${version}";
  version = "${baseVersion}.${minorVersion}";

  src = fetchurl {
    url = "http://www.spass-prover.org/download/sources/spass${baseVersion}${minorVersion}.tgz";
    sha256 = "11cyn3kcff4r79rsw2s0xm6rdb8bi0kpkazv2b48jhcms7xw75qp";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ bison flex ];

  buildPhase = ''
    make RM="rm -f" proparser.c ${extraTools} opt
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -m0755 SPASS ${extraTools} $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Automated theorem prover for first-order logic";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    downloadPage = "http://www.spass-prover.org/download/index.html";
  };
}
