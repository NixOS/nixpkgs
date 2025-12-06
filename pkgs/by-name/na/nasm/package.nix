{
  lib,
  stdenv,
  fetchurl,
  perl,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "nasm";
  version = "3.01";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-tzJMvobnZ7ZfJvRn7YsSrYDhJOPMuJB2hVyY5Dqe3dQ=";
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

  meta = with lib; {
    homepage = "https://www.nasm.us/";
    description = "80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pSub
    ];
    mainProgram = "nasm";
    license = licenses.bsd2;
  };
}
