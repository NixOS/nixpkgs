# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{ mkDerivation, base, cmdargs, directory, fetchFromGitHub, filepath, lib
, megaparsec, mtl, parser-combinators, safe-exceptions, scientific
, text, transformers, unix
}:
mkDerivation {
  pname = "nixfmt";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixfmt";
    rev = "136005fc3dd34ff0d6af9f8c57cd1d3d7d342537";
    sha256 = "sha256-g0MTMQZeRlKFQiKdEVc1IQ73nNeRwu0+GtUIvcm2NV4=";
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
