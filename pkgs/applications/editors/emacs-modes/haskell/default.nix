{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "haskell-mode-13.10";

  src = fetchurl {
    url = "https://github.com/haskell/haskell-mode/archive/v13.10.tar.gz";
    sha256 = "0hcg7wpalcdw8j36m8vd854zrrgym074r7m903rpwfrhx9mlg02b";
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
