{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mutmut";
  version = "3.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "boxed";
    rev = "refs/tags/${version}";
    hash = "sha256-+e2FmfpGtK401IW8LNqeHk0v8Hh5rF3LbZJkSOJ3yPY=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace-fail 'junit-xml==1.8' 'junit-xml==1.9'
  '';

  disabled = python3Packages.pythonOlder "3.7";

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    click
    parso
    junit-xml
    setproctitle
    textual
  ];

  meta = with lib; {
    description = "mutation testing system for Python, with a strong focus on ease of use";
    mainProgram = "mutmut";
    homepage = "https://github.com/boxed/mutmut";
    changelog = "https://github.com/boxed/mutmut/blob/${version}/HISTORY.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      l0b0
      synthetica
    ];
  };
}
