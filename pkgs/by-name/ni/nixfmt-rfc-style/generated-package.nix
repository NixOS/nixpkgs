# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{ mkDerivation, base, cmdargs, directory, fetchzip, filepath, lib
, megaparsec, mtl, parser-combinators, pretty-simple
, safe-exceptions, scientific, text, transformers, unix
}:
mkDerivation {
  pname = "nixfmt";
  version = "0.6.0";
  src = fetchzip {
    url = "https://github.com/nixos/nixfmt/archive/698954723ecec3f91770460ecae762ce590f2d9e.tar.gz";
    sha256 = "1k057nxj58ghid15gd4xi19whaavqgspypk69r0qshb5bhl74nm5";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base megaparsec mtl parser-combinators pretty-simple scientific
    text transformers
  ];
  executableHaskellDepends = [
    base cmdargs directory filepath safe-exceptions text unix
  ];
  jailbreak = true;
  homepage = "https://github.com/NixOS/nixfmt";
  description = "The official formatter for Nix code";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
