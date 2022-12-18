{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "control-lock";

  src = fetchurl {
    url = "https://github.com/emacsmirror/emacswiki.org/blob/185fdc34fb1e02b43759ad933d3ee5646b0e78f8/control-lock.el";
    sha256 = "1b5xcgq2r565pr1c14dwrmn1fl05p56infapa5pqvajv2kpfla7h";
  };

  dontUnpack = true;

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install $src $out/share/emacs/site-lisp/control-lock.el
  '';

  meta = {
    description = "Like caps-lock, but for your control key.  Give your pinky a rest!";
    homepage = "https://www.emacswiki.org/emacs/control-lock.el";
    platforms = lib.platforms.all;
  };
}
