{stdenv, fetchurl, emacs}:

stdenv.mkDerivation {
  name = "org-mac-link-1.2";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/stuartsierra/org-mode/master/contrib/lisp/org-mac-link.el";
    sha256 = "1gkzlfbhg289r1hbqd25szan1wizgk6s99h9xxjip5bjv0jywcx5";
  };

  phases = [ "buildPhase" "installPhase"];

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
    homepage = https://orgmode.org/worg/org-contrib/org-mac-link.html;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
