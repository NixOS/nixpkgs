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

  meta = with lib; {
    description = "Implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.sikmir ] ++ teams.podman.members;
    mainProgram = "podman-compose";
  };
}
