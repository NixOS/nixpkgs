{ mkDerivation, aeson, aeson-pretty, base, binary, bytestring
, directory, fetchgit, filepath, HTF, HUnit, mtl
, optparse-applicative, parsec, process, shelly, stdenv, text
, transformers, unix, zlib
}:
mkDerivation {
  pname = "super-user-spark";
  version = "0.2.0.3";
  src = fetchgit {
    url = "https://github.com/NorfairKing/super-user-spark";
    sha256 = "1w9c2b1fxqxp2q5jxsvnrfqvyvpk8q70qqsgzshmghx0yylx9cns";
    rev = "a7d132f7631649c3a093ede286e66f78e9793fba";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson aeson-pretty base binary bytestring directory filepath HTF
    mtl optparse-applicative parsec process shelly text transformers
    unix zlib
  ];
  testHaskellDepends = [
    aeson aeson-pretty base binary bytestring directory filepath HTF
    HUnit mtl optparse-applicative parsec process shelly text
    transformers unix zlib
  ];
  jailbreak = true;
  description = "Configure your dotfile deployment with a DSL";
  license = stdenv.lib.licenses.mit;
  homepage = "https://github.com/NorfairKing/super-user-spark";
  maintainers = [ stdenv.lib.maintainers.badi ];
}
