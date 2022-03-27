{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "control-lock";

  src = fetchurl {
    url = "http://emacswiki.org/emacs/download/control-lock.el";
    sha256 = "1vjpiagiy581qy2ljkbp0w12gvdqzx2lg0778z93262jf55ycai4";
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
