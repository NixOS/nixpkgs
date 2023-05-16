{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
<<<<<<< HEAD
  version = "0.9.4";
=======
  version = "0.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-MFg518iodxdHbr7k5kpkTWI59Kk7pPwyIVswVcjasl8=";
=======
    hash = "sha256-L7uM5v2CYGFHYxzBUKlMF+ChtjBM24GZ8NuyoQaOU6U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonRelaxDeps = [
    "aiorun"
    "aiosqlite"
    "click"
    "pyunifiprotect"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiocron
    aiorun
    aiosqlite
    apprise
<<<<<<< HEAD
    async-lru
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    click
    expiring-dict
    python-dateutil
    pyunifiprotect
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python tool to backup unifi event clips in realtime";
    homepage = "https://github.com/ep1cman/unifi-protect-backup";
    changelog = "https://github.com/ep1cman/unifi-protect-backup/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 ];
  };
}
