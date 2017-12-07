{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "prolog-mode-1.25";

  src = fetchurl {
    url = "http://bruda.ca/_media/emacs/prolog.el";
    sha256 = "0hfd2dr3xc5qxgvc08nkb2l5a05hfldahdc6ymi9vd8798cc46yh";
  };

  buildCommand = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp $src $out/share/emacs/site-lisp/prolog.el
  '';

  meta = {
    homepage = http://bruda.ca/emacs/prolog_mode_for_emacs/;
    description = "Prolog mode for Emacs";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
