{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "steamback";
  version = "0.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hvMPSxIfwwQqo80JCpYhcbVY4kXs5jWtjjafVSMrw6o=";
  };

  build-system = with python3Packages; [
    setuptools
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
