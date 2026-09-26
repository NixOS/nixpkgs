{
  lib,
  python3Packages,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aw-watcher-steam";
  version = "0-unstable-2025-06-16";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Edwardsoen";
    repo = "aw-watcher-steam";
    rev = "55ea988994acfbf729fa43612f2057a310c1cc8f";
    hash = "sha256-wd+q83MlgMeiYSHQwMtszwnDrkaDN3yVkV/P5HsU89U=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    aw-client
    requests
  ];

  pythonImportsCheck = [
    "aw_watcher_steam"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/Edwardsoen/aw-watcher-steam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      atemu
    ];
    mainProgram = "aw-watcher-steam";
  };
})
