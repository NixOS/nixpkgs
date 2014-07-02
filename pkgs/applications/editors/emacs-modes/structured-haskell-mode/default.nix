{ cabal, emacs, haskellMode, haskellSrcExts }:

cabal.mkDerivation (self: {
  pname = "structured-haskell-mode";
  version = "1.0.3";
  sha256 = "0axmw8bj51q8v0wd4jp6giw9dnv0mp7kp8yd16s4nm4hcqgrh5h2";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ haskellSrcExts haskellMode ];
  buildTools = [ emacs ];
  postInstall = ''
    emacs -L elisp -L ${haskellMode}/share/emacs/site-lisp \
      --batch -f batch-byte-compile "elisp/"*.el
    install -d $out/share/emacs/site-lisp
    install "elisp/"*.el "elisp/"*.elc  $out/share/emacs/site-lisp
  '';
  meta = {
    homepage = "https://github.com/chrisdone/structured-haskell-mode";
    description = "Structured editing Emacs mode for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
