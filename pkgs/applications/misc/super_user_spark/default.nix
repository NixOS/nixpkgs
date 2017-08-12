{ mkDerivation, fetchgit, aeson, aeson-pretty, base, bytestring, directory
, filepath, hspec, hspec-core, HUnit, mtl, optparse-applicative
, parsec, process, pureMD5, QuickCheck, shelly, stdenv, text
, transformers, unix
}:
mkDerivation {
  pname = "super-user-spark";
  version = "0.3.2.0-dev";
  src = fetchgit {
    url = "https://github.com/NorfairKing/super-user-spark";
    sha256 = "0akyc51bghzkk8j75n0i8v8rrsklidwvljhx3aibxfbkqp33372g";
    rev = "ab8635682d67842b9e6d909cf3c618014e4157f2";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring directory filepath mtl
    optparse-applicative parsec process pureMD5 shelly text
    transformers unix
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    aeson aeson-pretty base bytestring directory filepath hspec
    hspec-core HUnit mtl optparse-applicative parsec process pureMD5
    QuickCheck shelly text transformers unix
  ];
  jailbreak = true;
  description = "Configure your dotfile deployment with a DSL";
  license = stdenv.lib.licenses.mit;
  homepage = https://github.com/NorfairKing/super-user-spark;
  maintainers = [ stdenv.lib.maintainers.badi ];
}
