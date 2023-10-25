{ lib, fetchFromGitHub, haskellPackages, makeWrapper, eprover }:

with haskellPackages; mkDerivation {
  pname = "Naproche-SAD";
  version = "2022-10-24";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    rev = "c8c4ca2d5fdb92bf17e0e54c99bd2a9691255d80";
    sha256 = "0xvh6kkl5k5ygp2nrbq3k0snvzczbmcp1yrwdkah3fzhf9i3yykx";
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
