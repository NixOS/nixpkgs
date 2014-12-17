{ stdenv, fetchgit, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "haskell-mode-20141113";

  src = fetchgit {
    url = "https://github.com/haskell/haskell-mode.git";
    sha256 = "fc2a15f3a88f2343663e8b078464991a1af5ffe36c8158ee4f61c5d0358c9daf";
  };

  buildInputs = [ emacs texinfo ];

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
