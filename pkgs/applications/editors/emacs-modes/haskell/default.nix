{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "haskell-mode-13.07";

  src = fetchurl {
    url = "https://github.com/haskell/haskell-mode/archive/v13.07.tar.gz";
    sha256 = "15c8ncj9mykkrizy1a8l94gq37s8hj13v3p5rgyaj9z0cwgl85kx";
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
