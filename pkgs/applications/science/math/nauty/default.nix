{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "nauty-${version}";
  version = "26r10";
  src = fetchurl {
    url = "http://pallini.di.uniroma1.it/nauty${version}.tar.gz";
    sha256 = "16pdklh066z6mx424wkisr88fz9divn2caj7ggs03wy3y848spq6";
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
