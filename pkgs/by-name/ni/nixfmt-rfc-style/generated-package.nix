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
    url = "https://github.com/nixos/nixfmt/archive/14be7e665024f1a8c31d748b22f5e215856d3479.tar.gz";
    sha256 = "017a1069sy4bhc2wchgd5hl6c106spf0zq5dcg65mf4flba1xs0j";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base megaparsec mtl parser-combinators pretty-simple scientific
    text transformers
  ];
  executableHaskellDepends = [
    base bytestring cmdargs directory file-embed filepath
    safe-exceptions text unix
  ];
  jailbreak = true;
  homepage = "https://github.com/NixOS/nixfmt";
  description = "Official formatter for Nix code";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
