{ lib, buildPythonApplication, fetchFromGitHub, pyyaml }:

buildPythonApplication rec {
  version = "0.1.8";
  pname = "podman-compose";

  # "This project is still under development." -- README.md
  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    rev = version;
    sha256 = "sha256-BN6rG46ejYY6UCNjKYQpxPQGTW3x12zpGDnH2SKn304=";
  };

  propagatedBuildInputs = [ pyyaml ];

  meta = {
    description = "An implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sikmir ] ++ lib.teams.podman.members;
  };
}
