{ mkDerivation, base, bytestring, cardano-wallet-test-utils
, code-page, contra-tracer, either, extra, fetchgit, filepath, fmt
, hspec, hspec-core, hspec-discover, hspec-expectations
, iohk-monitoring, lib, process, retry, text, text-class, time
, unix, unliftio, unliftio-core
}:
mkDerivation {
  pname = "cardano-wallet-launcher";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/launcher; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring code-page contra-tracer either extra filepath fmt
    iohk-monitoring process text text-class unix unliftio unliftio-core
  ];
  testHaskellDepends = [
    base bytestring cardano-wallet-test-utils contra-tracer fmt hspec
    hspec-core hspec-expectations iohk-monitoring process retry text
    text-class time unliftio
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Utilities for a building commands launcher";
  license = lib.licenses.asl20;
}
