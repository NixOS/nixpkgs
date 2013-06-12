{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "haskell-mode-2.9.1-102-g8d4b965";

  src = fetchurl {
    url = "https://github.com/haskell/haskell-mode/tarball/8d4b9651a69b62fcbedbac63de29a1e87ff0e97f";
    sha256 = "02sil43885xjbfqakrxkm7bjnjd930lx6845fc2rxmkq5plkq85a";
    name = "${name}.tar.gz";
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
