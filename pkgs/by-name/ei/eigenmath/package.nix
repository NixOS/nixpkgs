{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "337-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "622740aa22d11d08016d0ac962aa920f5e38f223";
    hash = "sha256-sFiCYvp+SC8CnkMfoUXpAPFySd5nxiqLRVGiWsZ4FcY=";
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
