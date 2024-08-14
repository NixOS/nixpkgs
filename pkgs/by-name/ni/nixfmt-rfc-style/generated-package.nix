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
    url = "https://github.com/nixos/nixfmt/archive/a707c70ab6fed71032ac55bb1029306a50a80d34.tar.gz";
    sha256 = "1v5hch8j1w1bvn2r4xz4ym60ykgsc074y28vpin9qraagv06x8sm";
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
