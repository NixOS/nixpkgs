{ cabal, alex, binary, Cabal, cautiousFile, concreteTyperep
, dataDefault, derive, Diff, dlist, dyre, filepath, fingertree
, glib, gtk, hashable, hint, HUnit, lens, mtl, pango, parsec
, pointedlist, QuickCheck, random, regexBase, regexTdfa, safe
, split, tasty, tastyHunit, tastyQuickcheck, time, transformersBase
, uniplate, unixCompat, unorderedContainers, utf8String, vty
, xdgBasedir
, withPango ? true

# User may need extra dependencies for their configuration file so we
# want to specify it here to have them available when wrapping the
# produced binary.
, extraDepends ? [ ]
}:

cabal.mkDerivation (self: {
  pname = "yi";
  version = "0.8.2";
  sha256 = "18rnyswsdzkh0jdcqfg8pr90mpm6xf11siv598svqkxg12d2qql9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary Cabal cautiousFile concreteTyperep dataDefault derive Diff
    dlist dyre filepath fingertree hashable hint lens mtl
    parsec pointedlist QuickCheck random regexBase regexTdfa safe
    split time transformersBase uniplate unixCompat unorderedContainers
    utf8String vty xdgBasedir
  ] ++ (if withPango then [ pango gtk glib ] else [ ]) ++ extraDepends;
  testDepends = [
    filepath HUnit QuickCheck tasty tastyHunit tastyQuickcheck
  ];
  buildTools = [ alex ];
  configureFlags = if withPango then "-fpango" else "-f-pango";
  doCheck = false;

  # https://ghc.haskell.org/trac/ghc/ticket/9170
  noHaddock = self.ghc.version == "7.6.3";

  # Allows Yi to find the libraries it needs at runtime.
  postInstall = ''
    mv $out/bin/yi $out/bin/.yi-wrapped
    cat - > $out/bin/yi <<EOF
    #! ${self.stdenv.shell}
    # Trailing : is necessary for it to pick up Prelude &c.
    export GHC_PACKAGE_PATH=$(${self.ghc.GHCGetPackages} ${self.ghc.version} \
                              | sed 's/-package-db\ //g' \
                              | sed 's/^\ //g' \
                              | sed 's/\ /:/g')\
    :$out/lib/ghc-${self.ghc.version}/package.conf.d/yi-$version.installedconf:

    eval exec $out/bin/.yi-wrapped "\$@"
    EOF
    chmod +x $out/bin/yi
  '';

  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "The Haskell-Scriptable Editor";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.fuuzetsu ];
  };
})
