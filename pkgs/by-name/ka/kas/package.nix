{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  kas,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kas";
  version = "5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = "kas";
    tag = version;
    hash = "sha256-KSmLQBOYyuO9o3YZYPJPDPeGudtNYIC2yghAu98sf3Q=";
  };

  patches = [ ./pass-terminfo-env.patch ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    setuptools # pkg_resources is imported during runtime
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

  pythonImportsCheck = [ "kas" ];

  meta = with lib; {
    homepage = "https://github.com/siemens/kas";
    description = "Setup tool for bitbake based projects";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
