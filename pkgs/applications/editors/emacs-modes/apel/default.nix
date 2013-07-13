{stdenv, fetchgit, emacs}:

stdenv.mkDerivation rec {
  name = "apel-git";

  src = fetchgit {
    url = "http://github.com/wanderlust/apel";
    rev = "beca6c4fc58fdc0f8923b320265ec5a304850f50";
  };

  buildInputs = [emacs];

  preConfigure = ''
    cat << EOF > APEL-CFG
    (setq APEL_DIR "$out/share/emacs/site-lisp/apel")
    (setq EMU_DIR "$out/share/emacs/site-lisp/emu")
    EOF
  '';

  meta = {
    description = "APEL";
    homepage = http://nya.org/;
    license = "GPL";
  };
}
