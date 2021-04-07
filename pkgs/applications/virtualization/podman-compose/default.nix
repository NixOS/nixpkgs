{ lib, buildPythonApplication, fetchPypi, pyyaml }:

buildPythonApplication rec {
  version = "0.1.5";
  pname = "podman-compose";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sgbc889zq127qhxa9frhswa1mid19fs5qnyzfihx648y5i968pv";
  };

  propagatedBuildInputs = [ pyyaml ];

  meta = {
    description = "An implementation of docker-compose with podman backend";
    homepage = "https://github.com/containers/podman-compose";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sikmir ] ++ lib.teams.podman.members;
  };
}
