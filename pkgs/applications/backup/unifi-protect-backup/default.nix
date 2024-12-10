{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
  version = "0.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = "unifi-protect-backup";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ypx9drM9Ks3RR75lz2COflr6GF6Bm9D+GwJWPGwuq/c=";
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
