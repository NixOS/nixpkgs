# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  base,
  cmdargs,
  directory,
  fetchzip,
  filepath,
  lib,
  megaparsec,
  mtl,
  parser-combinators,
  pretty-simple,
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
    url = "https://github.com/nixos/nixfmt/archive/83de1eceaae8a891ae52a3a2b82226540207309e.tar.gz";
    sha256 = "0lnl9vlbyrfplmq3hpmpjlmhjdwwbgk900wgi25ib27v0mlgpnxp";
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
    cmdargs
    directory
    filepath
    safe-exceptions
    text
    unix
  ];
  jailbreak = true;
  homepage = "https://github.com/NixOS/nixfmt";
  description = "Official formatter for Nix code";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
