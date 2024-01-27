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
    url = "https://github.com/piegamesde/nixfmt/archive/1eff7a84ac82fbebb5f586244f1c80e1fcc4f494.tar.gz";
    sha256 = "1pg876sr58h7v087kbjsnfr4pzvqpwzibl06w2468qs1sywmd283";
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
