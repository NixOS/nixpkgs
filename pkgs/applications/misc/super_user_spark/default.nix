{ mkDerivation, aeson, aeson-pretty, base, bytestring, directory
, filepath, genvalidity, genvalidity-hspec, genvalidity-hspec-aeson
, genvalidity-path, hashable, hspec, hspec-core, mtl
, optparse-applicative, parsec, path, path-io, process, QuickCheck
, stdenv, text, transformers, unix, validity, validity-path
}:
mkDerivation {
  pname = "super-user-spark";
  version = "0.4.0.3";
  sha256 = "0z2alc67p8nvvwaxxrgwhkwfki1iw7ycs3ay8kyfw0wh01d2cmgk";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring directory filepath hashable mtl
    optparse-applicative parsec path path-io process text unix validity
    validity-path
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    aeson aeson-pretty base bytestring directory filepath genvalidity
    genvalidity-hspec genvalidity-hspec-aeson genvalidity-path hashable
    hspec hspec-core mtl optparse-applicative parsec path path-io
    process QuickCheck text transformers unix validity validity-path
  ];
  description = "Configure your dotfile deployment with a DSL";
  license = stdenv.lib.licenses.mit;
  doCheck = false;
  jailbreak = true;
  homepage = https://github.com/NorfairKing/super-user-spark;
  maintainers = [ stdenv.lib.maintainers.badi ];
}
