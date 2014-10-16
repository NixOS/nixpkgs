# This is a manually-written expression over an in-tree cabal file.
# It's awkward but this way allows the package user to pass in
# extraPackages without much extra hassle on their end, similarly how
# the XMonad service handles it: the difference is that we don't have
# anything like XMONAD_GHC…
#
# The idea is that the user changes their configs using any libraries
# he likes and then builds it using this expression. Once that's done,
# ‘reload’ and similar functions should all work as long as the user
# doesn't need new libraries at which point they should add them to
# extraPackages and rebuild from the expression.
{ cabal, yi, extraPackages, makeWrapper }:

cabal.mkDerivation (self: rec {
  pname = "yi-custom";
  version = "0.0.0.1";
  src = ./yi-custom-cabal;
  isLibrary = true;
  buildDepends = extraPackages ++ [ yi ];
  buildTools = [ makeWrapper ];
  noHaddock = true;
  doCheck = false;

  # Allows Yi to find the libraries it needs at runtime. We drop ‘:’
  # from this GHC_PACKAGE_PATH because we're wrapping over a different
  # wrapper that used --prefix: if we didn't, we end up with a
  # double-colon, confusing GHC.
  postInstall = ''
    makeWrapper ${yi}/bin/yi $out/bin/yi --set GHC_PACKAGE_PATH ''${GHC_PACKAGE_PATH%?}
  '';

  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "Wrapper over user-specified Haskell libraries for use in Yi config";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
    # The wrapper does not yet work properly if we actually try to use it.
    broken = true;
  };

})