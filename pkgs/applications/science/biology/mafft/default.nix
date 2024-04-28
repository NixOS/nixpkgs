{
  lib,
  stdenv,
  fetchFromGitLab,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mafft";
  version = "7.526";

  src = fetchFromGitLab {
    owner = "sysimm";
    repo = "mafft";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VNe00r12qEkLEbpZdJCe5xZ73JA3uAmuAeG+eSeRDI0=";
  };

  preBuild = ''
    cd ./core
    make clean
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "Multiple alignment program for amino acid or nucleotide sequences";
    homepage = "https://mafft.cbrc.jp/alignment/software/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
