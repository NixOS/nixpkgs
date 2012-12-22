{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "haskell-mode-2.8.0.29-gae3e4499d2";

  src = fetchgit {
    url = "http://github.com/haskell/haskell-mode.git";
    rev = "ae3e4499d27a1468bdf88ffe0ce15cd7e4bb9f2a";
    sha256 = "29a1725da620c13ff2b3b56906e76dd9f19317eee92bd5750b3aa9a4264effae";
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
