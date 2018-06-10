{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "helm-words-20150413";

  src = fetchgit {
    url = "https://github.com/pronobis/helm-words.git";
    rev = "637aa3a7e9cfd34e0127472c5b1f993a4da26185";
    sha256 = "19l8vysjygscr1nsddjz2yv0fjhbsswfq40rdny8zsmaa6qhpj35";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Emacs major mode for jade and stylus";
    homepage = https://github.com/brianc/helm-words;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
