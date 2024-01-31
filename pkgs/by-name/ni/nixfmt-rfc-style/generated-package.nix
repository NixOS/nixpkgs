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
    url = "https://github.com/piegamesde/nixfmt/archive/d6930fd0c62c4d7ec9e4a814adc3d2f590d96271.tar.gz";
    sha256 = "1ijrdzdwricv4asmy296j7gzvhambv96nlxi3qrxb4lj1by6a34m";
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
