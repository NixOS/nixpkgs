{ mkDerivation, lib, fetchFromGitHub
, aeson, base, bytestring, containers, criterion
, doctest, Glob, mersenne-random-pure64, mtl
, optparse-applicative, parsec, random, regex-tdfa, scientific
, text, time, unordered-containers, uuid, vector
}:

mkDerivation rec {
  pname = "mkjson";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "mfussenegger";
    repo = "mkjson";
    rev = "${version}";
    hash = "sha256-+NDLFtsWWxHv/6XC9hJOAHPU6YED5oHqS/j5BPwNsqA=";
  };

  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers mersenne-random-pure64 mtl
    optparse-applicative parsec random regex-tdfa scientific text time
    unordered-containers uuid vector
  ];
  executableHaskellDepends = [
    aeson base bytestring containers mersenne-random-pure64 mtl
    optparse-applicative parsec random regex-tdfa scientific text time
    unordered-containers uuid vector
  ];
  testHaskellDepends = [
    aeson base bytestring containers doctest Glob
    mersenne-random-pure64 mtl optparse-applicative parsec random
    regex-tdfa scientific text time unordered-containers uuid vector
  ];
  benchmarkHaskellDepends = [
    aeson base bytestring containers criterion mersenne-random-pure64
    mtl optparse-applicative parsec random regex-tdfa scientific text
    time unordered-containers uuid vector
  ];

  description = "Commandline tool to generate static or random JSON records";
  homepage = "https://github.com/mfussenegger/mkjson";
  license = lib.licenses.mit;
  maintainers = with lib.maintainers; [ athas ];
  mainProgram = "mkjson";
}
