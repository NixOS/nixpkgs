{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "js2-mode-0-20141118";

  src = fetchgit {
    url = "git://github.com/mooz/js2-mode.git";
    rev = "3abcd90ddc2f446ddf0fb874dd79ba870c26ad2d";
    sha256 = "0sh9ax2w0ydhjjn4vnwbgy3926p7ad6h6nmsnm0a3zlldj9a4vwn";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile js2-mode.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp js2-mode.el js2-mode.elc $out/share/emacs/site-lisp/
  '';
}
