{ cabal, emacs, haskellSrcExts }:

cabal.mkDerivation (self: {
  pname = "structured-haskell-mode";
  version = "1.0.2";
  sha256 = "1lwdhlr38y5hdr78nplplr3q0hrjhryw378f1857qh0lvp03gwl2";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ haskellSrcExts ];
  buildTools = [ emacs ];
  postInstall = ''
    emacs -L elisp --batch -f batch-byte-compile "elisp/"*.el
    install -d $out/share/emacs/site-lisp
    install "elisp/"*.elc $out/share/emacs/site-lisp
  '';
  meta = {
    homepage = "https://github.com/chrisdone/structured-haskell-mode";
    description = "Structured editing Emacs mode for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.pSub ];
  };
})
