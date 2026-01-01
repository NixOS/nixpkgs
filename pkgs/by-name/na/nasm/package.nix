{
  lib,
  stdenv,
  fetchurl,
  perl,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "nasm";
<<<<<<< HEAD
  version = "3.01";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-tzJMvobnZ7ZfJvRn7YsSrYDhJOPMuJB2hVyY5Dqe3dQ=";
=======
  version = "2.16.03";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-FBKhx2C70F2wJrbA0WV6/9ZjHNCmPN229zzG1KphYUg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make golden
    make test

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/netwide-assembler/nasm.git";
    rev-prefix = "nasm-";
    ignoredVersions = "rc.*";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://www.nasm.us/";
    description = "80x86 and x86-64 assembler designed for portability and modularity";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pSub
    ];
    mainProgram = "nasm";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    homepage = "https://www.nasm.us/";
    description = "80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pSub
    ];
    mainProgram = "nasm";
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
