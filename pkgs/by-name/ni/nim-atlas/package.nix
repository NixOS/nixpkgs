{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  openssl,
}:

buildNimPackage (
  final: prev: {
    pname = "atlas";
    version = "unstable-2023-09-22";
    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "atlas";
      rev = "ab22f997c22a644924c1a9b920f8ce207da9b77f";
      hash = "sha256-TsZ8TriVuKEY9/mV6KR89eFOgYrgTqXmyv/vKu362GU=";
    };
    buildInputs = [ openssl ];
    prePatch = ''
      rm config.nims
    ''; # never trust a .nims file
    doCheck = false; # tests will clone repos
    meta = final.src.meta // {
      description = "Nim package cloner";
      mainProgram = "atlas";
      license = [ lib.licenses.mit ];
    };
  }
)
