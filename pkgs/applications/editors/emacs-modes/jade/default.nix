{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "jade-mode-0-20120802";

  src = fetchgit {
    url = "https://github.com/brianc/jade-mode.git";
    rev = "275ab149edb0f6bcfae6ac17ba456f3351191604";
    sha256 = "3cd2bebcd66e59d60b8e5e538e65a8ffdfc9a53b86443090a284e8329d7cb09b";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -L . -f batch-byte-compile *.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Emacs major mode for jade and stylus";
    homepage = https://github.com/brianc/jade-mode;
    license = "GPLv2+";

    platforms = stdenv.lib.platforms.all;
  };
}
