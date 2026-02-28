{
  lib,
  fetchPypi,
  frida-tools,
  litecli,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "objection";
  version = "1.12.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Qwkn7LPfW/k3G4yLcuX9I1/3bZQf7tdrWFaRZycjNLQ=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies =
    with python3Packages;
    [
      click
      delegator-py
      flask
      frida-python
      packaging
      prompt-toolkit
      pygments
      requests
      semver
      setuptools
      tabulate
    ]
    ++ [
      frida-tools
      litecli
    ];

  pythonImportsCheck = [ "objection" ];

  meta = {
    description = "Instrumented mobile pentest framework";
    homepage = "https://github.com/sensepost/objection";
    changelog = "https://github.com/sensepost/objection/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "objection";
    maintainers = with lib.maintainers; [ caverav ];
    platforms = python3Packages.frida-python.meta.platforms;
  };
})
