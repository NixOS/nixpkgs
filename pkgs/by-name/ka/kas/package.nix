{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  kas,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kas";
  version = "4.8.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "siemens";
    repo = "kas";
    tag = version;
    hash = "sha256-mDfGiWZKipbaXxlyx8JWeFvSyE44FcumYD9Pr/38UBQ=";
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
