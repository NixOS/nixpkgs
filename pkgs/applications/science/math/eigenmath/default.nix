{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "3.27-unstable-2024-08-24";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "92ae1a3f9c9f6808f3faefa10ae66c0ff480dab2";
    hash = "sha256-AHZ9p7yyYENHywNppsSTfaM3KFqpX5ehxfjPwocHv5Q=";
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
