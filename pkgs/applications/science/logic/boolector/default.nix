{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "boolector-${version}";
  version = "2.4.1";
  src = fetchurl {
    url    = "http://fmv.jku.at/boolector/boolector-${version}-with-lingeling-bbc.tar.bz2";
    sha256 = "0mdf7hwix237pvknvrpazcx6s3ininj5k7vhysqjqgxa7lxgq045";
  };

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
