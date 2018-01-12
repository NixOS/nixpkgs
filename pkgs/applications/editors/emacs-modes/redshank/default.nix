{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "redshank";
  name = "${pname}-20120510";

  src = fetchgit {
    url = "http://www.foldr.org/~michaelw/projects/redshank.git";
    rev = "f98e68f532e622bcd464292ca4a9cf5fbea14ebb";
    sha256 = "1jdkgvd5xy9hl5q611jwah2n05abjp7qcy9sj4k1z11x0ii62b6p";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Common Lisp Editing Extensions (for Emacs)";
    homepage = http://www.foldr.org/~michaelw/emacs/redshank/;
    platforms = stdenv.lib.platforms.all;
  };
}
