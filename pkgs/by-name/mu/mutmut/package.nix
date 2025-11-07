{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mutmut";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mutmut";
    owner = "boxed";
    tag = version;
    hash = "sha256-+e2FmfpGtK401IW8LNqeHk0v8Hh5rF3LbZJkSOJ3yPY=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace-fail 'junit-xml==1.8' 'junit-xml==1.9'
  '';

  disabled = python3Packages.pythonOlder "3.7";

  doCheck = false;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    click
    parso
    junit-xml
    setproctitle
    textual
  ];

  pythonImportsCheck = [ "mutmut" ];

  meta = {
    description = "Mutation testing system for Python, with a strong focus on ease of use";
    mainProgram = "mutmut";
    homepage = "https://github.com/boxed/mutmut";
    changelog = "https://github.com/boxed/mutmut/blob/${version}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      l0b0
      synthetica
    ];
  };
}
