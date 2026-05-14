{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  nix-update-script,
  qbit-manage,
}:
python3Packages.buildPythonApplication rec {
  pname = "qbit-manage";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "StuffAnThings";
    repo = "qbit_manage";
    tag = "v${version}";
    hash = "sha256-cPN4GhB7TuhiGau8Nb9hVNubF6fppyS2tuFGJ+spPaI=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace "==" ">="
  '';

  dependencies = with python3Packages; [
    argon2-cffi
    bencode-py
    croniter
    fastapi
    gitpython
    humanize
    pytimeparse2
    qbittorrent-api
    requests
    retrying
    ruamel-yaml
    slowapi
    uvicorn
  ];

  pythonRelaxDeps = [
    "croniter"
    "fastapi"
    "requests"
    "uvicorn"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = qbit-manage;
        command = "env HOME=$TMPDIR qbit-manage --version";
      };
    };
  };

  meta = {
    description = "This tool will help manage tedious tasks in qBittorrent and automate them";
    homepage = "https://github.com/StuffAnThings/qbit_manage";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flyingpeakock ];
    platforms = lib.platforms.all;
    mainProgram = "qbit-manage";
  };
}
