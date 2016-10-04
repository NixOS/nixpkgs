{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "let-alist-1.0.3";

  src = fetchurl {
    url = "http://elpa.gnu.org/packages/let-alist-1.0.3.el";
    sha256 = "12n1cmjc7hzyy0jmsdxqz1hqzg4ri4nvvi0p9mw1d6v44xzfm0mx";
  };

  buildInputs = [ emacs ];

  unpackPhase = "cp -v ${src} let-alist.el";
  buildPhase = "emacs --batch -f batch-byte-compile let-alist.el";

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    mv -v *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = "http://elpa.gnu.org/packages/let-alist.html";
    description = "Easily let-bind values of an assoc-list by their names";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
