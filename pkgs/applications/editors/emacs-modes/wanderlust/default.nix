{stdenv, fetchgit, emacs, apel, flim, semi}:

stdenv.mkDerivation rec {
  name = "wanderlust-git";

  src = fetchgit {
    url = "http://github.com/wanderlust/wanderlust";
    rev = "5e1ccbda73e29657fc05dc05aa9717eff02fdf71";
  };

  buildInputs = [emacs apel flim semi];

  preConfigure = ''
    cat << EOF > WL-CFG
    (add-to-list 'load-path "${apel}/share/emacs/site-lisp/apel")
    (add-to-list 'load-path "${apel}/share/emacs/site-lisp/emu")
    (add-to-list 'load-path "${flim}/share/emacs/site-lisp/flim")
    (add-to-list 'load-path "${semi}/share/emacs/site-lisp/semi")
    (require 'install)
    (setq LISPDIR "$out/share/emacs/site-lisp")
    (setq PIXMAPDIR (concat "$out/share/emacs/" emacs-version "/etc/wl/icons"))
    EOF
    cat WL-CFG
  '';

  meta = {
    description = "wanderlust";
    homepage = http://nya.org/;
    license = "GPL";
  };
}
