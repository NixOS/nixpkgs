{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "babeld";
  version = "1.13.1";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/${pname}-${version}.tar.gz";
    hash = "sha256-FfJNJtoMz8Bzq83vAwnygeRoTyqnESb4JlcsTIRejdk=";
  };

<<<<<<< HEAD
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail "-lrt" ""
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc"
  ];

  passthru.tests.babeld = nixosTests.babeld;

<<<<<<< HEAD
  meta = {
    homepage = "http://www.irif.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "http://www.irif.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "babeld";
  };
}
