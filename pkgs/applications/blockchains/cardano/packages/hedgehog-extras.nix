{ mkDerivation, aeson, aeson-pretty, async, base, bytestring
, deepseq, directory, exceptions, fetchgit, filepath, hedgehog, lib
, mmorph, mtl, network, process, resourcet, stm, temporary, text
, time, transformers, unliftio, unordered-containers, yaml
}:
mkDerivation {
  pname = "hedgehog-extras";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/hedgehog-extras/";
    sha256 = "0wc7qzkc7j4ns2rz562h6qrx2f8xyq7yjcb7zidnj7f6j0pcd0i9";
    rev = "edf6945007177a638fbeb8802397f3a6f4e47c14";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson aeson-pretty async base bytestring deepseq directory
    exceptions filepath hedgehog mmorph mtl network process resourcet
    stm temporary text time transformers unliftio unordered-containers
    yaml
  ];
  description = "Supplemental library for hedgehog";
  license = lib.licenses.asl20;
}
