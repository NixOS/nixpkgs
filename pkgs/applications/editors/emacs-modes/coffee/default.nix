{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name = "coffee-mode-0.4.1";

  src = fetchgit {
    url = "https://github.com/defunkt/coffee-mode.git";
    rev = "c45c5f7a529363bc7aa57db0f3df26389fd233d8";
    sha256 = "36a7792b5ffbcc5a580e8d5b2425494c60a8015cfde0e3f8a946a685da231ce2";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile coffee-mode.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install coffee-mode.el coffee-mode.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Emacs major mode for CoffeeScript, unfancy JavaScript";
    homepage = https://github.com/defunkt/coffee-mode;
    license = "GPLv2+";

    platforms = stdenv.lib.platforms.all;
  };
}
