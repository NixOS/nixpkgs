{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "338-unstable-2025-04-18";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "2e11a03c19d9f8194a14b8578bcffc3d76d3b113";
    hash = "sha256-Clsch47VfLqGi6RaQF8T+6cSRpsZjjJDMUYTK3tSidg=";
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
