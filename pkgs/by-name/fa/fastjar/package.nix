{
  lib,
  callPackage,
  fetchzip,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastjar";
  version = "0.98";

  src = fetchzip {
    pname = "fastjar-source";
    inherit (finalAttrs) version;
    url = "mirror://savannah/fastjar/fastjar-${finalAttrs.version}.tar.gz";
    hash = "sha256-8VyKNQaPLrXAy/UEm2QkBx56SSSoLdU/7w4IwrxbsQc=";
  };

  outputs = [
    "out"
    "info"
    "man"
  ];

  buildInputs = [ zlib ];

  strictDeps = true;

  doCheck = true;

  passthru = {
    tests = lib.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./tests;
    };
  };

  meta = {
    homepage = "https://savannah.nongnu.org/projects/fastjar/";
    description = "Fast Java archiver written in C";
    longDescription = ''
      FastJar is an attempt at creating a feature-for-feature copy of Sun's
      JDK's 'jar' command.  Sun's jar (or Blackdown's for that matter) is
      written entirely in Java which makes it dog slow.  Since FastJar is
      written in C, it can create the same .jar file as Sun's tool in a fraction
      of the time.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "fastjar";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
