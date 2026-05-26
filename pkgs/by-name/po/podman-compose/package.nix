{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  version = "1.5.0";
  pname = "podman-compose";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AEnq0wsDHaCxefaEX4lB+pCAIKzN0oyaBNm7t7tK/yI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    python-dotenv
    pyyaml
  ];

  propagatedBuildInputs = [ python3Packages.pypaBuildHook ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    parameterized
  ];

  disabledTestPaths = [
    "tests/integration" # requires running podman
  ];

  # versionCheckHook requires podman executable

  meta = {
    description = "Implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sikmir ];
    teams = [ lib.teams.podman ];
    mainProgram = "podman-compose";
  };
})
