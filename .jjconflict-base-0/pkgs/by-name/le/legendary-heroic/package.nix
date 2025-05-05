{
  lib,
  gitUpdater,
  fetchFromGitHub,
  python3Packages,
}:
let
  version = "0.20.36";
in
python3Packages.buildPythonApplication {
  pname = "legendary-heroic";
  inherit version;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "legendary";
    rev = version;
    sha256 = "sha256-+aywgd5RZfkmVuA0MaF2/Ie4a5If/zQxvVCcTfGpQpE=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    filelock
  ];

  disabled = python3Packages.pythonOlder "3.8";

  pythonImportsCheck = [ "legendary" ];

  meta = with lib; {
    description = "Free and open-source Epic Games Launcher alternative";
    longDescription = ''
      This is the Heroic Games Launcher's fork of legendary.
    '';
    homepage = "https://github.com/Heroic-Games-Launcher/legendary";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aidalgol ];
    mainProgram = "legendary";
  };

  passthru.updateScript = gitUpdater { };
}
