{ lib, buildPythonApplication, fetchFromGitHub, pyyaml }:

buildPythonApplication rec {
  version = "0.2.0pre-2021-05-18";
  pname = "podman-compose";

  # "This project is still under development." -- README.md
  #
  # As of May 2021, the latest release (0.1.5) has fewer than half of all
  # commits. This project seems to have no release management, so the last
  # commit is the best one until proven otherwise.
  src = fetchFromGitHub {
    repo = "podman-compose";
    owner = "containers";
    rev = "62d2024feecf312e9591cc145f49cee9c70ab4fe";
    sha256 = "17992imkvi6129wvajsp0iz5iicfmh53i20qy2mzz17kcz30r2pp";
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
