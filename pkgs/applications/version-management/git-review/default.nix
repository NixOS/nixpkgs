{ lib
, fetchFromGitea
, buildPythonApplication
, pbr
, requests
, setuptools
, gitUpdater
}:

buildPythonApplication rec {
  pname = "git-review";
  version = "2.2.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = version;

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "opendev";
    repo = pname;
    rev = version;
    sha256 = "sha256-2+X5fPxB2FIp1fwqEUc+W0gH2NjhF/V+La+maE+XEpo=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    requests
    setuptools # implicit dependency, used to get package version through pkg_resources
  ];

  # Don't run tests because they pull in external dependencies
  # (a specific build of gerrit + maven plugins), and I haven't figured
  # out how to work around this yet.
  doCheck = false;

  pythonImportsCheck = [ "git_review" ];

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    description = "Tool to submit code to Gerrit";
    homepage = "https://opendev.org/opendev/git-review";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
