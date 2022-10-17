{ lib, buildPythonApplication, fetchFromGitHub, python-dotenv, pyyaml }:

buildPythonApplication rec {
  version = "1.0.3";
  pname = "podman-compose";

  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    rev = "v${version}";
    sha256 = "sha256-Si/O4dx9bqqRp/hTv3WbTXj46OM+PpyPBnQQWUqcZfs=";
  };

  propagatedBuildInputs = [ pyyaml python-dotenv ];

  meta = {
    description = "An implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sikmir ] ++ lib.teams.podman.members;
  };
}
