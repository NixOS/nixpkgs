# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  base,
  cmdargs,
  directory,
  fetchgit,
  filepath,
  lib,
  megaparsec,
  parser-combinators,
  safe-exceptions,
  scientific,
  text,
  unix,
}:
mkDerivation {
  pname = "nixfmt";
  version = "0.6.0";
  src = fetchgit {
    url = "https://github.com/NixOS/nixfmt.git";
    sha256 = "0yh1baanifnv5fl3d7ixkgaki7ka1big0kxkiv4h5rik6zkqfyqz";
    rev = "7e9e06eefed52d6d698b828ee83b83ea5c163f3b";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    megaparsec
    parser-combinators
    scientific
    text
  ];
  executableHaskellDepends = [
    base
    cmdargs
    directory
    filepath
    safe-exceptions
    text
    unix
  ];
  jailbreak = true;
  homepage = "https://github.com/serokell/nixfmt";
  description = "An opinionated formatter for Nix";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
