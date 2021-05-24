{ stdenv, cedille, emacs }:

stdenv.mkDerivation {
  pname = "cedille-mode";
  version = cedille.version;

  src = cedille.src;

  buildInputs = [ emacs ];

  buildPhase = ":";

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install se-mode/*.el se-mode/*.elc $out/share/emacs/site-lisp
    install cedille-mode/*.el cedille-mode/*.elc $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
    substituteInPlace $out/share/emacs/site-lisp/cedille-mode.el \
      --replace /usr/bin/cedille ${cedille}/bin/cedille \

  '';

  meta = {
    description = "Emacs major mode for Cedille";
    homepage    = cedille.meta.homepage;
    license     = cedille.meta.license ;
    platforms   = cedille.meta.platforms;
    maintainers = cedille.meta.maintainers;
  };
}
