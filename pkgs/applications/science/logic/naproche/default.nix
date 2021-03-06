{ lib, fetchFromGitHub, haskellPackages }:

with haskellPackages; mkDerivation {
  pname = "Naproche-SAD";
  version = "0.1.0.0";

  src = fetchFromGitHub {
    owner = "naproche-community";
    repo = "naproche";
    # This revision is used by Isabelle
    rev = "755224402e36bf8276c9e3d5a8eeb024bb911b85";
    sha256 = "0zlxj10iksnn3j295b91n23y9cxwxa8d95c326karsv59bpzvaz3";
  };

  isExecutable = true;
  # test suite requires 'stack exec'
  doCheck = false;
  libraryToolDepends = [ hpack ];

  executableHaskellDepends = [
    base bytestring containers ghc-prim mtl network process split text
    threads time transformers utf8-string uuid yaml
  ];

  prePatch = "hpack";

  homepage = "https://github.com/naproche-community/naproche#readme";
  description = "Write formal proofs in natural language and LaTeX";
  maintainers = with lib.maintainers; [ NieDzejkob ];
  license = lib.licenses.gpl3Only;
}
