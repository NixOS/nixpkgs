{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mafft";
  version = "7.487";

  src = fetchurl {
    url = "https://mafft.cbrc.jp/alignment/software/mafft-${version}-with-extensions-src.tgz";
    sha256 = "1wcfbpfivi6xx87xdswp0gfksandija8j8hbw1f9506ra5gga1ga";
  };

  preBuild = ''
    cd ./core
    make clean
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "PREFIX=$(out)" ];

  meta = with lib;
    {
      description = "Multiple alignment program for amino acid or nucleotide sequences";
      homepage = "https://mafft.cbrc.jp/alignment/software/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ natsukium ];
      platforms = platforms.unix;
    };
}
