{ mkDerivation, aeson, aeson-pretty, base, bytestring, directory
, filepath, fetchgit, genvalidity, genvalidity-hspec, genvalidity-hspec-aeson
, genvalidity-path, hashable, hspec, hspec-core, mtl
, optparse-applicative, parsec, path, path-io, process, QuickCheck
, stdenv, text, transformers, unix, validity, validity-path
}:
mkDerivation {
  pname = "super-user-spark";
  version = "0.4.0.4";
  src = fetchgit {
    url = "https://github.com/NorfairKing/super-user-spark";
    sha256 = "0akyc51bghzkk8j75n0i8v8rrsklidwvljhx3aibxfbkqp33372g";
    rev = "ab8635682d67842b9e6d909cf3c618014e4157f2";
  };
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
  homepage = "https://github.com/NorfairKing/super-user-spark";
  description = "Configure your dotfile deployment with a DSL";
  license = stdenv.lib.licenses.mit;
  maintainers = [ stdenv.lib.maintainers.badi ];
}

