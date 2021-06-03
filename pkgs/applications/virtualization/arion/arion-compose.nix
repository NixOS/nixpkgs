{ mkDerivation, aeson, aeson-pretty, async, base, bytestring
, directory, hspec, lens, lens-aeson, lib, optparse-applicative
, process, protolude, QuickCheck, temporary, text, unix
}:
mkDerivation {
  pname = "arion-compose";
  version = "0.1.3.0";
  sha256 = "9e18448f8489303f0d9fee020ad1ceb896f4e71eedb537c0c0ef0f1f3ade80df";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-pretty async base bytestring directory lens lens-aeson
    process protolude temporary text unix
  ];
  executableHaskellDepends = [
    aeson aeson-pretty async base bytestring directory lens lens-aeson
    optparse-applicative process protolude temporary text unix
  ];
  testHaskellDepends = [
    aeson aeson-pretty async base bytestring directory hspec lens
    lens-aeson process protolude QuickCheck temporary text unix
  ];
  homepage = "https://github.com/hercules-ci/arion#readme";
  description = "Run docker-compose with help from Nix/NixOS";
  license = lib.licenses.asl20;
}
