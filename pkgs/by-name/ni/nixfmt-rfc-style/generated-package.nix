# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  base,
  bytestring,
  cmdargs,
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
  version = "0.6.0";
  src = fetchzip {
    url = "https://github.com/nixos/nixfmt/archive/3261d1016ecc753c59ff92767a257f91b587e705.tar.gz";
    sha256 = "0jk6mgp710iwxyc7wa5kzz0p0rpcwbbs21smnv14cyii0jniz42s";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
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
