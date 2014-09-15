{stdenv, fetchurl, emacs}:

let version = "1.3.8";

in stdenv.mkDerivation {
  name = "emacs-rainbow-delimiters-${version}";

  src = fetchurl {
    url = "https://github.com/jlr/rainbow-delimiters/archive/${version}.tar.gz";
    sha256 = "1xavygdnd9q80wqavxliks0w662mvn8v79qmg0kr494yfqc5hw6h";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';
}
