{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python-dotenv,
  pyyaml,
  setuptools,
  pipBuildHook,
  pypaBuildHook,
}:

buildPythonApplication rec {
  version = "1.1.0";
  pname = "podman-compose";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    rev = "v${version}";
    sha256 = "sha256-uNgzdLrnDIABtt0L2pvsil14esRzl0XcWohgf7Oksr8=";
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
    description = "An implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sikmir ] ++ lib.teams.podman.members;
    mainProgram = "podman-compose";
  };
}
