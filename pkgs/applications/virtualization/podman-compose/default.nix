{ lib, buildPythonApplication, fetchFromGitHub, python-dotenv, pyyaml, setuptools, pypaBuildHook }:

buildPythonApplication rec {
  version = "1.2.0";
  pname = "podman-compose";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    rev = "v${version}";
    hash = "sha256-40RatexY/6eRfCodaiBeJpyt1sDUj2STSPL0gBECdRs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ python-dotenv pyyaml ];
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
