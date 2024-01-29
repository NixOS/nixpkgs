{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = "unifi-protect-backup";
    rev = "refs/tags/v${version}";
    hash = "sha256-KT2saPpkAS/6X491i0Y8+jr8JPD51iQx+YGT5zRTtcU=";
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
    aiolimiter
    aiorun
    aiosqlite
    apprise
    async-lru
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
    maintainers = teams.helsinki-systems.members;
    mainProgram = "unifi-protect-backup";
  };
}
