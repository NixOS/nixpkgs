{stdenv, fetchgit, emacs, apel}:

stdenv.mkDerivation rec {
  name = "flim-git";

  src = fetchgit {
    url = "http://github.com/wanderlust/flim";
    rev = "d435c3626d2e07cc62f084930b6d5eca66f6768c";
  };

  buildInputs = [emacs apel];

  preConfigure = ''
    cat << EOF > FLIM-CFG
    (add-to-list 'load-path "${apel}/share/emacs/site-lisp/apel")
    (add-to-list 'load-path "${apel}/share/emacs/site-lisp/emu")
    (require 'install)
    (setq PREFIX "$out/share")
    (setq LISPDIR "$out/share/emacs/site-lisp")
    (setq FLIM_DIR "$out/share/emacs/site-lisp/flim")
    EOF
    cat FLIM-CFG
  '';

  meta = {
    description = "FLIM";
    homepage = http://nya.org/;
    license = "GPL";
  };
}
