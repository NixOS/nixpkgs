{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "prolog-mode";
  version = "1.28";

  src = fetchurl {
    url = "http://bruda.ca/_media/emacs/prolog.el";
    sha256 = "ZzIDFQWPq1vI9z3btgsHgn0axN6uRQn9Tt8TnqGybOk=";
  };

  buildCommand = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp $src $out/share/emacs/site-lisp/prolog.el
  '';

  meta = {
    homepage = "https://bruda.ca/emacs/prolog_mode_for_emacs/";
    description = "Prolog mode for Emacs";
    license = lib.licenses.gpl2Plus;
  };
}
