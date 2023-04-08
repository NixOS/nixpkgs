{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "unstable-2023-04-07";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "dd6a01da6e7f52a15af5bd584e93edf1a77bc04b";
    hash = "sha256-GZkC/Tvep7fL5nJyz0ZN7z0lUhGX4EJlXVswwAyegUE=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm555 eigenmath "$out/bin/eigenmath"
    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib;{
    description = "Computer algebra system written in C";
    homepage = "https://georgeweigt.github.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
  };
}
