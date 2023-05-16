{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
<<<<<<< HEAD
  version = "unstable-2023-08-03";
=======
  version = "unstable-2023-05-12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
<<<<<<< HEAD
    rev = "f202cf0c342e54e994c4d416daecc1b1dc8b9c98";
    hash = "sha256-kp4zWTPYt2DiuPgTK+ib8NbKg2BJVxJDDCvIlWNuwgs=";
=======
    rev = "a6de473ad8eb7cd7c2fba6a738881764dc2c5f83";
    hash = "sha256-1fdGx6pYWnoyJ5ei1qZlXZG2mUEdjrRI7+X352XE/7A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    platforms = platforms.unix;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
