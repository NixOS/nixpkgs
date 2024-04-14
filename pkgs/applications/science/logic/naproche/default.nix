{ lib, fetchFromGitHub, haskellPackages, makeWrapper, eprover }:

with haskellPackages; mkDerivation {
  pname = "Naproche-SAD";
  version = "unstable-2024-01-18";

  src = fetchFromGitHub {
    owner = "naproche";
    repo = "naproche";
    rev = "bb3dbcbd2173e3334bc5bdcd04c07c6836a11387";
    hash = "sha256-DWcowUjy8/VBuhqvDYlVINHssF4KhuzT0L+m1YwUxoE=";
  };

  isExecutable = true;

  buildTools = [ hpack makeWrapper ];
  executableHaskellDepends = [
    base array bytestring containers ghc-prim megaparsec mtl network process
    split temporary text threads time transformers uuid
  ];

  prePatch = "hpack";
  doCheck = false; # Tests are broken in upstream

  postInstall = ''
    wrapProgram $out/bin/Naproche-SAD \
      --set-default NAPROCHE_EPROVER ${eprover}/bin/eprover
  '';

  homepage = "https://github.com/naproche/naproche#readme";
  description = "Write formal proofs in natural language and LaTeX";
  maintainers = with lib.maintainers; [ jvanbruegge ];
  license = lib.licenses.gpl3Only;
  mainProgram = "Naproche-SAD";
}
