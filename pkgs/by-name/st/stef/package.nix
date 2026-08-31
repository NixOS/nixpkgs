{
  python3Packages,
  fetchPypi,
  lib,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "stef";
  version = "1.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zUmCgfTomEQk6ipbOKF41bdarWWqXsjhBxbg1oe3aIY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    docker
    termcolor
  ];

  pythonImportsCheck = [
    "stef.base"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Submission TEst Framework";
    longDescription = ''
      Testing framework for stdin/stdout. Its intended use is automatically testing submissions of students.
    '';
    homepage = "https://pypi.org/project/stef";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandrutocar ];
    mainProgram = "stef_runtests";
  };
}
