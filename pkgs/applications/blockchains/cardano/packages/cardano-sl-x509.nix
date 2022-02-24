{ mkDerivation, aeson, asn1-encoding, asn1-types, base
, base64-bytestring, bytestring, cardano-prelude, cryptonite
, data-default-class, directory, exceptions, fetchgit, filepath
, hedgehog, hourglass, ip, lib, QuickCheck, text
, unordered-containers, wide-word, x509, x509-store
, x509-validation, yaml
}:
mkDerivation {
  pname = "cardano-sl-x509";
  version = "3.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-sl-x509/";
    sha256 = "1kma25g8sl6m3pgsihja7fysmv6vjdfc0x7dyky9g5z156sh8z7i";
    rev = "12925934c533b3a6e009b61ede555f8f26bac037";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson asn1-encoding asn1-types base base64-bytestring bytestring
    cardano-prelude cryptonite data-default-class directory exceptions
    filepath hourglass ip text unordered-containers wide-word x509
    x509-store x509-validation yaml
  ];
  testHaskellDepends = [
    base cardano-prelude exceptions hedgehog QuickCheck
  ];
  homepage = "https://github.com/input-output-hk/cardano-sl/x509/README.md";
  description = "Tool-suite for generating x509 certificates specialized for RSA with SHA-256";
  license = lib.licenses.mit;
}
