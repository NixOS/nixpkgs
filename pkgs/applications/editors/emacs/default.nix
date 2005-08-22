{stdenv, fetchurl, xlibs}:

stdenv.mkDerivation {
  name = "emacs-21.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/emacs-21.3.tar.gz;
    md5 = "a0bab457cbf5b4f8eb99d1d0a3ada420";
  };
  patches = [./patchfile];
  inherit (xlibs) libXaw libX11;

  buildInputs = [xlibs.libXaw xlibs.libX11];
}
