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
  version = "1.3.0";
  pname = "podman-compose";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    tag = "v${version}";
    hash = "sha256-0k+vJwWYEXQ6zxkcvjxBv9cq8nIBS15F7ul5VwqYtys=";
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
    maintainers = [ lib.maintainers.sikmir ] ++ lib.teams.podman.members;
    mainProgram = "podman-compose";
  };
}
