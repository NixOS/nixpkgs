{stdenv, fetchgit, emacs, apel, flim}:

stdenv.mkDerivation rec {
  name = "semi-git";

  src = fetchgit {
    url = "http://github.com/wanderlust/semi";
    rev = "e81b1ec56a5d2c8ae352df1cd6a7eaa2532097f0";
  };

  buildInputs = [emacs apel flim];

  preConfigure = ''
    cat << EOF > SEMI-CFG
    (add-to-list 'load-path "${apel}/share/emacs/site-lisp/apel")
    (add-to-list 'load-path "${apel}/share/emacs/site-lisp/emu")
    (add-to-list 'load-path "${flim}/share/emacs/site-lisp/flim")
    (require 'install)
    (setq PREFIX "$out")
    (setq METHOD_DIR "$out/share/semi")
    (setq LISPDIR "$out/share/emacs/site-lisp")
    (setq SEMI_KERNEL_DIR "$out/share/emacs/site-lisp/semi")
    (setq SETUP_FILE_DIR "$out/share/emacs/site-lisp/semi")
    EOF
    cat SEMI-CFG
  '';

  meta = {
    description = "SEMI";
    homepage = http://nya.org/;
    license = "GPL";
  };
}
