{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "helm-words-20190917";

  src = fetchgit {
    url = "https://github.com/pronobis/helm-words.git";
    rev = "e6387ece1940a06695b9d910de3d90252efb8d29";
    sha256 = "1ly0mbzlgc26fqvf7rxpmy698g0cf9qldrwrx022ar6r68l1h7xf";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Emacs major mode for jade and stylus";
    homepage = "https://github.com/brianc/helm-words";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
