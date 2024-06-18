{ lib
, fetchFromGitHub
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      pyunifiprotect = super.pyunifiprotect.overridePythonAttrs {
        version = "unstable-2024-06-08";
        src = fetchFromGitHub {
          owner = "ep1cman";
          repo = "pyunifiprotect";
          rev = "d967bca2c65e0aa6a7363afb6367c3745c076747";
          hash = "sha256-gSAK/T9cjIiRC/WjwrdLP+LHzEEUsNbwpXClYqpnMio=";
        };
      };
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "unifi-protect-backup";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ep1cman";
    repo = "unifi-protect-backup";
    rev = "refs/tags/v${version}";
    hash = "sha256-t4AgPFqKS6u9yITIkUUB19/SxVwR7X8Cc01oPx3M+E0=";
  };

  pythonRelaxDeps = [
    "aiorun"
    "aiosqlite"
    "click"
    "pyunifiprotect"
  ];

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python.pkgs; [
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

  nativeCheckInputs = with python.pkgs; [
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
