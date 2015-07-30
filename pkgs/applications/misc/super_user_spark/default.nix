{ mkDerivation, fetchurl, ghc, aeson, aeson-pretty, base, binary, bytestring
, directory, filepath, HTF, HUnit, mtl, parsec, process, shelly
, stdenv, text, transformers, unix, xdg-basedir
, happy
}:

mkDerivation rec {
  pname = "super-user-spark";
  version = "0.1.0.0";

  src = fetchurl {
    url = "https://github.com/NorfairKing/super-user-spark/archive/v0.1.tar.gz";
    sha256 = "90258cb2d38f35b03867fdf82dbd49500cdec04f3cf05d0eaa18592cb44fe13f";
  };

  isLibrary = false;
  isExecutable = true;
  jailbreak = true;

  buildDepends = [
    aeson aeson-pretty base binary bytestring directory filepath HTF
    mtl parsec process shelly text transformers unix xdg-basedir happy
  ];
  testDepends = [
    aeson aeson-pretty base binary bytestring directory filepath HTF
    HUnit mtl parsec process shelly text transformers unix xdg-basedir
  ];
  license = stdenv.lib.licenses.mit;
  homepage = "https://github.com/NorfairKing/super-user-spark";
  description = "A safe way to never worry about your beautifully configured system again";
  platforms = ghc.meta.platforms;
  maintainers = stdenv.lib.maintainers.badi;
}
