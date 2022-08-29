{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mafft";
  version = "7.505";

  src = fetchurl {
    url = "https://mafft.cbrc.jp/alignment/software/mafft-${version}-with-extensions-src.tgz";
    sha256 = "sha256-9Up4Zw/NmWAjO8w7PdNZ85WnHAztRae+HP6uGZUM5v8=";
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
