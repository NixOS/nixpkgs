{ stdenv, fetchurl, emacs, unzip }:

stdenv.mkDerivation {
  name = "emacs-monky-20150404";

  src = fetchurl {
    url = "https://github.com/ananthakumaran/monky/archive/48c0200910739b6521f26f6423b2bfb8c38b4482.zip";
    sha256 = "0yp3pzddx7yki9n3qrriqa5p442qyrdivvlc4xbl024vzjyzddrj";
  };

  buildInputs = [ emacs unzip ];

  buildPhase = "emacs -L . --batch -f batch-byte-compile *.el";

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';
}
