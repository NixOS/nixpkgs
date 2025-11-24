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
mkDerivation {
  pname = "nix-run";
  version = "0.1.0.0-unstable-2025-10-29";
  src = fetchgit {
    url = "https://tangled.org/weethet.bsky.social/nix-run";
    sha256 = "0lyb3dxndc7yrnfnd77a20qkxsdmdzf9wbch0pvv9ifprzr5cmhm";
    rev = "73d7bf6b58848fb8f42e3a69816e0847f041c689";
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
