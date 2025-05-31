{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python-dotenv,
  pyyaml,
  setuptools,
  pypaBuildHook,
}:

buildPythonApplication rec {
  version = "1.4.0";
  pname = "podman-compose";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    tag = "v${version}";
    hash = "sha256-779L8fc5rxnkW5f4i/zgc8K9bEwKNKjw20cNlSwU/aA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-dotenv
    pyyaml
  ];
  propagatedBuildInputs = [ pypaBuildHook ];

  meta = {
    description = "Implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sikmir ];
    teams = [ lib.teams.podman ];
    mainProgram = "podman-compose";
  };
}
