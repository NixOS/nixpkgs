{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
  version = "0.9.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yPYzFZ4eI1wvBZgSP4Z90zyS+0vrDtf0uRz60byE5XA=";
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
