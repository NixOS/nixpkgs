{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "0-unstable-2024-05-12";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "978b3bd582a90c8e82079f2e4e4a3a5038cbbe08";
    hash = "sha256-DoGX8nUcWcioTq8ymB+HLsCnt9V6HTKSX4Zs2CQz78Q=";
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
