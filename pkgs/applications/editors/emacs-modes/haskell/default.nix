{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "haskell-mode-2.8.0.29-g7682f99";

  src = fetchgit {
    url = "http://github.com/haskell/haskell-mode.git";
    rev = "7682f991acd63d9400597d5f4980f62d7b1c4c0b";
    sha256 = "f4508a11fa65ece237c9ee9f623bc4e9ad3d3d58ab2fcacc8ddb080c29aac717";
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
