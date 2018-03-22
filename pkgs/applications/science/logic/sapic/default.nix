{ stdenv, fetchurl, unzip, ocaml }:

stdenv.mkDerivation rec {
  name = "sapic-${version}";
  version = "0.9";

  src = fetchurl {
    url    = "http://sapic.gforge.inria.fr/${name}.zip";
    sha256 = "1ckl090lpyfh90mkjhnpcys5grs3nrl9wlbn9nfkxxnaivn2yx9y";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ ocaml ];
  patches = [ ./native.patch ]; # create a native binary, not a bytecode one

  buildPhase = "make depend && make";
  installPhase = ''
    mkdir -p $out/bin
    cp ./sapic $out/bin
  '';

  meta = {
    description = "Stateful applied Pi Calculus for protocol verification";
    homepage    = http://sapic.gforge.inria.fr/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
