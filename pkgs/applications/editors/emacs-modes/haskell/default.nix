{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "haskell-mode-2.8.0.29-gc906ee1";

  src = fetchgit {
    url = "http://github.com/haskell/haskell-mode.git";
    rev = "c906ee1fcc03a7c1c670bcaf9a8c8dc99117fca1";
    sha256 = "a0857a690d85e09ea3ce94a9467335a91fee6a41b9fbc1165f42d1e91723877a";
  };

  buildInputs = [emacs];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp *.el *.elc *.hs "$out/share/emacs/site-lisp/"
  '';

  meta = {
    homepage = "http://github.com/haskell/haskell-mode";
    description = "Haskell mode for Emacs";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
