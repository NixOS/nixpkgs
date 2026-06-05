# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  base,
  bytestring,
  cmdargs,
  containers,
  directory,
  fetchzip,
  file-embed,
  filepath,
  lib,
  megaparsec,
  mtl,
  parser-combinators,
  pretty-simple,
  process,
  safe-exceptions,
  scientific,
  text,
  transformers,
  unix,
}:
mkDerivation {
  pname = "nixfmt";
  version = "1.2.0";
  src = fetchzip {
    url = "https://github.com/nixos/nixfmt/archive/v1.2.0.tar.gz";
    sha256 = "1qvj1sddh7bgggqnj7cnhvfh4iz1pwzc9a9awc1g7y349yvpwad3";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    containers
    megaparsec
    mtl
    parser-combinators
    pretty-simple
    scientific
    text
    transformers
  ];
  executableHaskellDepends = [
    base
    bytestring
    cmdargs
    directory
    file-embed
    filepath
    process
    safe-exceptions
    text
    transformers
    unix
  ];
  jailbreak = true;
  homepage = "https://github.com/NixOS/nixfmt";
  description = "Official formatter for Nix code";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
