{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "0-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "e5fc4a44797549da9d8994203547da63002b3700";
    hash = "sha256-pX8rRIrOq0fQvzVrvAh47ZBzdkS6ZKuXTQ9joa/XJgg=";
  };

  checkPhase =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
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

  meta = with lib; {
    description = "Computer algebra system written in C";
    mainProgram = "eigenmath";
    homepage = "https://georgeweigt.github.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.unix;
  };
}
