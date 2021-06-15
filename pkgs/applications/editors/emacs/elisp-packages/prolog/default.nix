{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "prolog-mode";
  version = "1.28";

  src = fetchurl {
    url = "http://bruda.ca/_media/emacs/prolog.el";
    sha256 = "oCMzks4xuor8Il8Ll8PXh1zIvMl5qN0RCFJ9yKiHOHU=";
  };

  buildCommand = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp $src $out/share/emacs/site-lisp/prolog.el
  '';

  meta = {
    homepage = "http://bruda.ca/emacs/prolog_mode_for_emacs/";
    description = "Prolog mode for Emacs";
    license = lib.licenses.gpl2Plus;
  };
}
