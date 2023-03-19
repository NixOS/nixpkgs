{ lib, stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "mafft";
  version = "7.515";

  src = fetchFromGitLab {
    owner = "sysimm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ssZvjOHJLsBjB48sKr1U7VrRZUIduFkme22MdVbzoNk=";
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
