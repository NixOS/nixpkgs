{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "3.27-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "ba00d77289f1c9ce64108b1bbcee02c71ce48633";
    hash = "sha256-yFzsMNVjQK64uQSfjQKC8LbdQu7/97hDolRMBc4Womc=";
  };

  checkPhase = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    runHook preCheck

    for testcase in selftest1 selftest2; do
      ${emulator} ./eigenmath "test/$testcase"
    done

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 eigenmath "$out/bin/eigenmath"
    runHook postInstall
  '';

  doCheck = true;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib;{
    description = "Computer algebra system written in C";
    mainProgram = "eigenmath";
    homepage = "https://georgeweigt.github.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.unix;
  };
}
