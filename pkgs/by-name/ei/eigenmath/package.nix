{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "eigenmath";
  version = "340-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = "eigenmath";
    rev = "94fee6b02ebd4cd718dd9ea45583a6af2129dd28";
    hash = "sha256-2bdO0nRXhDZlEmGRfNf6g9zwc65Ih9Ymlo6PxlpAxes=";
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

  meta = {
    description = "Computer algebra system written in C";
    mainProgram = "eigenmath";
    homepage = "https://georgeweigt.github.io";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.unix;
  };
}
