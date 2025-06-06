{
  lib,
  stdenv,
  fetchFromGitLab,
  runCommand,
  mafft,
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

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      mkdir $out
      cd ${finalAttrs.src}/test
      ${lib.getExe mafft} sample > $out/test.fftns2
      ${lib.getExe mafft} --maxiterate 100  sample > $out/test.fftnsi
      ${lib.getExe mafft} --globalpair sample > $out/test.gins1
      ${lib.getExe mafft} --globalpair --maxiterate 100  sample > $out/test.ginsi
      ${lib.getExe mafft} --localpair sample > $out/test.lins1
      ${lib.getExe mafft} --localpair --maxiterate 100  sample > $out/test.linsi
      diff $out/test.fftns2 sample.fftns2
      diff $out/test.fftnsi sample.fftnsi
      diff $out/test.gins1 sample.gins1
      diff $out/test.ginsi sample.ginsi
      diff $out/test.lins1 sample.lins1
    '';
  };

  meta = with lib; {
    description = "Multiple alignment program for amino acid or nucleotide sequences";
    homepage = "https://mafft.cbrc.jp/alignment/software/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
