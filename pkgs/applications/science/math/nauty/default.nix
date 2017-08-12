{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "nauty-${version}";
  version = "26r7";
  src = fetchurl {
    url = "http://pallini.di.uniroma1.it/nauty${version}.tar.gz";
    sha256 = "1indcc1im7s5x89x0xn4699izw1wwars1aanpmf8jibnw66n9dcp";
  };
  buildInputs = [];
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/nauty}

    cp $(find . -type f -perm -111 \! -name '*.*' ) "$out/bin"
    cp [Rr][Ee][Aa][Dd]* COPYRIGHT This* [Cc]hange* "$out/share/doc/nauty"
  '';
  meta = {
    inherit version;
    description = ''Programs for computing automorphism groups of graphs and digraphs'';
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://pallini.di.uniroma1.it/;
  };
}
