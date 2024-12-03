# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{ mkDerivation, base, bytestring, cmdargs, directory, fetchzip
, file-embed, filepath, lib, megaparsec, mtl, parser-combinators
, pretty-simple, safe-exceptions, scientific, text, transformers
, unix
}:
mkDerivation {
  pname = "nixfmt";
  version = "0.6.0";
  src = fetchzip {
    url = "https://github.com/nixos/nixfmt/archive/cb92834560306868e4020dd643f09482587c6e7a.tar.gz";
    sha256 = "0fg2mdjny6i90bivw5d4wxl522azmcmikcak2ffgrq69qhjv21f6";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base megaparsec mtl parser-combinators pretty-simple scientific
    text transformers
  ];
  executableHaskellDepends = [
    base bytestring cmdargs directory file-embed filepath
    safe-exceptions text transformers unix
  ];
  jailbreak = true;
  homepage = "https://github.com/NixOS/nixfmt";
  description = "Official formatter for Nix code";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
