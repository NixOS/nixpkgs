{stdenv, fetchurl, ghc, zlib, ncurses, curl}:

stdenv.mkDerivation {
  name = "darcs-1.0.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/darcs-1.0.5.tar.gz;
    md5 = "9a9a4f84ed5b6258f7ab321713adf20b";
  };
  buildInputs = [ghc zlib ncurses curl];

  meta = {
    description = "Patch-based version management system";
  };
}
