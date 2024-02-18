{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "unstable-2024-02-04";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "3e37263611e181e2927d63b97b7656790c7f4fe1";
    hash = "sha256-gjmz9Ma7OLQyIry6i2HMNy4Ai5Wh5NUzDKPO2a9Hp+s=";
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
    homepage = "https://georgeweigt.github.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.unix;
  };
}
