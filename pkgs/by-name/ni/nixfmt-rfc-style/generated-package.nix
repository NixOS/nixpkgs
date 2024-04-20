# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{ mkDerivation, base, cmdargs, directory, fetchzip, filepath, lib
, megaparsec, mtl, parser-combinators, safe-exceptions, scientific
, text, transformers, unix
}:
mkDerivation {
  pname = "nixfmt";
  version = "0.5.0";
  src = fetchzip {
    url = "https://github.com/piegamesde/nixfmt/archive/2b5ee820690bae64cb4003e46917ae43541e3e0b.tar.gz";
    sha256 = "1i1jbc1q4gd7fpilwy6s3a583yl5l8d8rlmipygj61mpclg9ihqg";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base megaparsec mtl parser-combinators scientific text transformers
  ];
  executableHaskellDepends = [
    base cmdargs directory filepath safe-exceptions text unix
  ];
  jailbreak = true;
  homepage = "https://github.com/serokell/nixfmt";
  description = "An opinionated formatter for Nix";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
