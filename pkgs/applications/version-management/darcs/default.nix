{stdenv, fetchurl, ghc, zlib, ncurses, curl}:

stdenv.mkDerivation {
  name = "darcs-1.0.9rc2";
  src = fetchurl {
    url = http://abridgegame.org/darcs/darcs-1.0.9rc2.tar.gz;
    sha256 = "1as9xc9x7245nf1qw4smfwny08l04lmrr7cag9a32qglssxp528c";
  };
  buildInputs = [ghc zlib ncurses curl];

  meta = {
    description = "Patch-based version management system";
  };
}
