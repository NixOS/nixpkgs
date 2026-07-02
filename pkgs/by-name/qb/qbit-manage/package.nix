{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qbit-manage";
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "StuffAnThings";
    repo = "qbit_manage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iS6DiyPqRQo/NVczumZx06VYrWgCv+w9OK4jHDKE8PQ=";
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
    "qbittorrent-api"
    "requests"
    "uvicorn"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
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
})
