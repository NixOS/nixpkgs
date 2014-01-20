{ cabal, cmdargs, configurator, dyre, filepath, hoodleCore, mtl }:

cabal.mkDerivation (self: {
  pname = "hoodle";
  version = "0.2.2.1";
  sha256 = "1qkyyzfmprhniwarnq6cdmv1r6605b3h2lsc1rlalxhq6jh5gamd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs configurator dyre filepath hoodleCore mtl
  ];
  jailbreak = true;
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Executable for hoodle";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
