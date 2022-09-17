{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mafft";
  version = "7.490";

  src = fetchurl {
    url = "https://mafft.cbrc.jp/alignment/software/mafft-${version}-with-extensions-src.tgz";
    sha256 = "0hb5jzcqdnjn3micm5z301lrnyvmn9pnnnxjz4h2wa4yicyz7vnn";
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
