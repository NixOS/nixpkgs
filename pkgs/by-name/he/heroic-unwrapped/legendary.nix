{
  lib,
  gitUpdater,
  fetchFromGitHub,
  python3Packages,
}:
let
  version = "0.20.37";
in
python3Packages.buildPythonApplication {
  pname = "legendary-heroic";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "legendary";
    rev = version;
    sha256 = "sha256-mOys7lOPrrzBUBMIM/JvKygFQ/qIGD68BDNigk5BCIo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    filelock
  ];

  pythonImportsCheck = [ "legendary" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Free and open-source Epic Games Launcher alternative";
    longDescription = ''
      This is the Heroic Games Launcher's fork of legendary.
    '';
    homepage = "https://github.com/Heroic-Games-Launcher/legendary";
<<<<<<< HEAD
    license = lib.licenses.gpl3;
=======
    license = licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "legendary";
  };

  passthru.updateScript = gitUpdater { };
}
