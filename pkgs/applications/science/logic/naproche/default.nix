{ lib, fetchFromGitHub, haskellPackages, makeWrapper, eprover }:

with haskellPackages; mkDerivation {
  pname = "Naproche-SAD";
  version = "0.1.0.0";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    rev = "d39cea85ace04d5b3775fde9972a33886799bfe6";
    sha256 = "1zqrldmxkzbyg9bssrbwb00zic29904igcipaz1m9al0456yjnkf";
  };

  isExecutable = true;

  buildTools = [ hpack makeWrapper ];
  executableHaskellDepends = [
    base array bytestring containers ghc-prim megaparsec mtl network process
    split temporary text threads time transformers uuid
  ];

  prePatch = "hpack";

  checkPhase = ''
    export NAPROCHE_EPROVER=${eprover}/bin/eprover
    dist/build/Naproche-SAD/Naproche-SAD examples/cantor.ftl.tex -t 60 --tex=on
  '';

  postInstall = ''
    wrapProgram $out/bin/Naproche-SAD \
      --set-default NAPROCHE_EPROVER ${eprover}/bin/eprover
  '';

  homepage = "https://github.com/naproche/naproche#readme";
  description = "Write formal proofs in natural language and LaTeX";
  maintainers = with lib.maintainers; [ jvanbruegge ];
  license = lib.licenses.gpl3Only;
}
