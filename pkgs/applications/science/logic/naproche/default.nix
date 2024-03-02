{ lib, fetchFromGitHub, haskellPackages, makeWrapper, eprover }:

with haskellPackages; mkDerivation {
  pname = "Naproche-SAD";
  version = "unstable-2023-07-11";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    rev = "4c399d49a86987369bec6e1ac5ae3739cd6db0a8";
    sha256 = "sha256-Ji6yxbDEcwuYAzIZwK5sHNltK1WBFBfpyoEtoID/U4k=";
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
