{
  lib,
  fetchPypi,
  python3Packages,
  testers,
  salt-lint,
}:
python3Packages.buildPythonApplication rec {
  pname = "salt-lint";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f3Tmguf9eHIqbTkeqO3J/HlRE+z9QGV9aAV9QE7nvo4=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pathspec
    pyyaml
  ];

  pythonImportsCheck = [ "saltlint" ];

  passthru.tests = {
    version = testers.testVersion { package = salt-lint; };
  };

  meta = with lib; {
    description = "Command-line utility that checks for best practices in SaltStack";
    homepage = "https://salt-lint.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ norepercussions ];
    mainProgram = "salt-lint";
  };
}
