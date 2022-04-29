{ lib, fetchFromGitHub, haskellPackages, makeWrapper, eprover }:

with haskellPackages; mkDerivation {
  pname = "Naproche-SAD";
  version = "2022-04-19";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    rev = "2514c04e715395b7a839e11b63046eafb9c6a1da";
    sha256 = "1bdgyk4fk65xi7n778rbgddpg4zhggj8wjslxbizrzi81my9a3vm";
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
