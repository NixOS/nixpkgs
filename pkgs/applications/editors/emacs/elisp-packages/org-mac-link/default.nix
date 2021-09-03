{ lib, stdenv, fetchurl, emacs }:

stdenv.mkDerivation {
  pname = "org-mac-link";
  version = "1.2";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/stuartsierra/org-mode/master/contrib/lisp/org-mac-link.el";
    sha256 = "1gkzlfbhg289r1hbqd25szan1wizgk6s99h9xxjip5bjv0jywcx5";
  };

  dontUnpack = true;

  buildInputs = [ emacs ];

  buildPhase = ''
    cp $src org-mac-link.el
    emacs --batch -f batch-byte-compile org-mac-link.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install org-mac-link.el $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Insert org-mode links to items selected in various Mac apps";
    homepage = "https://orgmode.org/worg/org-contrib/org-mac-link.html";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
