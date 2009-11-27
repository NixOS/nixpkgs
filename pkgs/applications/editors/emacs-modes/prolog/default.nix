{stdenv, fetchurl}:

stdenv.mkDerivation
{
  name = "prolog-mode-1.22";
  src = fetchurl
  {
    url = "http://bruda.ca/emacs-prolog/prolog.el";
    sha256 = "f46915b2436642bb3302cb38cc457d3c121d0c3e95aecdf128fedc2ae5ea0c87";
  };

  buildCommand = "install -v -D -m644 $src $out/share/emacs/site-lisp/prolog.el";

  meta = {
    homepage = "http://turing.ubishops.ca/home/bruda/emacs-prolog/";
    description = "Prolog mode for Emacs";
    license = "GPL";
  };
}
