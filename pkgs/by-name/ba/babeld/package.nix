{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babeld";
  version = "1.14";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/babeld-${finalAttrs.version}.tar.gz";
    hash = "sha256-xO0TwEiAzMOoWplkXctkE0vqyKsGB/4ypNB+EFetc7c=";
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
