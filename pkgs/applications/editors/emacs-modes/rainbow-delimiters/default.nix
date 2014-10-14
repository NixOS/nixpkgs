{stdenv, fetchurl, emacs}:

let version = "1.3.12";

in stdenv.mkDerivation {
  name = "emacs-rainbow-delimiters-${version}";

  src = fetchurl {
    url = "https://github.com/jlr/rainbow-delimiters/archive/${version}.tar.gz";
    sha256 = "0l65rqmnrc02q1b406kxc29w5cfpmrmq0glv493pjzhzc5m3r63z";
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
