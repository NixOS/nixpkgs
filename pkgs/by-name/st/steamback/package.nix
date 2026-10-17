{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "steamback";
  version = "1.1.2-unstable-2025-11-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geeksville";
    repo = "steamback";
    rev = "c059ee3a3a0fe7bac8865224392ef6e70f9ea84c";
    hash = "sha256-APn0KRPIVlhASQofaTtorJrdqiCw+CwzYkORhaRNQ6s=";
  };

  build-system = with python3Packages; [
    poetry-core
    setuptools-scm
    wheel
  ];

  dependencies = with python3Packages; [
    psutil
    async-tkinter-loop
    timeago
    platformdirs
    sv-ttk
    pillow
  ];

  pythonRelaxDeps = [
    "async-tkinter-loop"
    "platformdirs"
    "pillow"
    "psutil"
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/steamback --help

    runHook postCheck
  '';

  pythonImportsCheck = [
    "steamback"
    "steamback.gui"
    "steamback.test"
    "steamback.util"
  ];

  meta = {
    description = "Decky plugin to add versioned save-game snapshots to Steam-cloud enabled games";
    mainProgram = "steamback";
    homepage = "https://github.com/geeksville/steamback";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ AngryAnt ];
  };
})
