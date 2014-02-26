{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name = "idris-mode-20140106";

  src = fetchgit {
    url = https://github.com/idris-hackers/idris-mode.git;
    rev = "47df65dd5b554c1d7cf70a07c3bd06d80867f870";
    sha256 = "55df66d1bace134bea83f0547e01daf068fc96dc080cf88ea8945ddcb2d08ea4";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Emacs major mode for Idris";
    homepage = https://github.com/idris-hackers/idris-mode;
    license = "GPLv3";

    platforms = stdenv.lib.platforms.all;
  };
}
