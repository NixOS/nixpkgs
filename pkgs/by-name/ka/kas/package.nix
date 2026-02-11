{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  kas,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "kas";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "siemens";
    repo = "kas";
    tag = finalAttrs.version;
    hash = "sha256-SQeoRm2bjcQmhfMUJCSxgKu7/qcIEv9ItWcLWkkNwAs=";
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

  meta = {
    homepage = "https://github.com/siemens/kas";
    description = "Setup tool for bitbake based projects";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bachp ];
  };
})
