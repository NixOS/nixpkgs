{
  mkDerivation,
  attoparsec,
  base,
  fetchgit,
  filepath,
  hercules-ci-optparse-applicative,
  hpack,
  lib,
  nix-derivation,
  process,
  relude,
  unix,
}:
mkDerivation rec {
  pname = "nix-run";
  version = "0.1.0.0-alpha.1";
  src = fetchgit {
    url = "https://tangled.org/weethet.bsky.social/nix-run";
    tag = version;
    sha256 = "0lyb3dxndc7yrnfnd77a20qkxsdmdzf9wbch0pvv9ifprzr5cmhm";
  };
  isLibrary = false;
  isExecutable = true;
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    attoparsec
    base
    filepath
    hercules-ci-optparse-applicative
    nix-derivation
    process
    relude
    unix
  ];
  prePatch = "hpack";
  homepage = "https://tangled.org/@weethet.bsky.social/nix-run";
  license = lib.licenses.bsd3;
  mainProgram = "nix-run";
}
