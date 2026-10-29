{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babeld";
  version = "1.13.1";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/babeld-${finalAttrs.version}.tar.gz";
    hash = "sha256-FfJNJtoMz8Bzq83vAwnygeRoTyqnESb4JlcsTIRejdk=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail "-lrt" ""
  '';

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc"
  ];

  passthru.tests.babeld = nixosTests.babeld;

  meta = {
    homepage = "http://www.irif.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "babeld";
  };
})
