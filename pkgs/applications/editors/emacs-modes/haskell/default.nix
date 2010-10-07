{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "haskell-mode-2.8.0";

  src = fetchurl {
    url = "http://projects.haskell.org/haskellmode-emacs/${name}.tar.gz";
    sha256 = "1065g4xy3ca72xhqh6hfxs5j3mls82bli8w5rhz1npzyfwlwhkb1";
  };

  buildInputs = [emacs];

  installPhase = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp *.el *.elc *.hs "$out/share/emacs/site-lisp/"
  '';

  meta = {
    homepage = "http://projects.haskell.org/haskellmode-emacs/";
    description = "Haskell mode package for Emacs";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
