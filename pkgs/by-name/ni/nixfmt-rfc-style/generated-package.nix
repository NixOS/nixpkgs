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
    url = "https://github.com/nixos/nixfmt/archive/c67a7b65906bd2432730929bd0e4957659c95b8e.tar.gz";
    sha256 = "03f00vwlla6i3m125389h3xjsl5xm07630ahm4w5gqwq1007y3r2";
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
  description = "An opinionated formatter for Nix";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
