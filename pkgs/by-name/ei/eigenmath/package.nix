{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "337-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "42a92c35d0ccc85fd8b16aa432c641edd3fa5b87";
    hash = "sha256-59iD5ivu2hPBfoxItfmTek4944ch6PlkAiVIimmvI5o=";
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
