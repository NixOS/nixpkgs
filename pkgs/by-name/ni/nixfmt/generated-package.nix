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
  version = "1.3.1";
  src = fetchzip {
    url = "https://github.com/nixos/nixfmt/archive/v1.3.1.tar.gz";
    sha256 = "1c0iz6hrzafld8vkldcmall7fvby6xgzzqgap8c3bxwhaxhq86hm";
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
  license = lib.meta.getLicenseFromSpdxId "MPL-2.0";
  mainProgram = "nixfmt";
}
