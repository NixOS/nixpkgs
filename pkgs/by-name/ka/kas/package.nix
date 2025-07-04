{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  kas,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kas";
  version = "4.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = "kas";
    tag = version;
    hash = "sha256-P2I3lLa8kuCORdlrwcswrWFwOA8lW2WL4Apv/2T7+f8=";
  };

  patches = [ ./pass-terminfo-env.patch ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    kconfiglib
    jsonschema
    distro
    pyyaml
    gitpython
  ];

  # Tests require network as they try to clone repos
  doCheck = false;
  passthru.tests.version = testers.testVersion {
    package = kas;
    command = "kas --version";
  };

  meta = with lib; {
    homepage = "https://github.com/siemens/kas";
    description = "Setup tool for bitbake based projects";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
