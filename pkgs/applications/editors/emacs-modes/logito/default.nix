{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name = "logito-0.1";

  src = fetchgit {
    url = "https://github.com/sigma/logito.git";
    rev = "824acb89d2cc18cb47281a4fbddd81ad244a2052";
    sha256 = "b9a7433417eafc5bc158f63dddf559b2044368eb3061f0264169de319c68fe4a";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile logito.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install logito.el logito.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "tiny logging framework for Emacs";
    homepage = https://github.com/sigma/logito;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
