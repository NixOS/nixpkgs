{ lib
, fetchurl
, buildPythonApplication
, pbr
, requests
, setuptools
}:

buildPythonApplication rec {
  pname = "git-review";
  version = "2.1.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = version;

  src = fetchurl {
    url = "https://opendev.org/opendev/${pname}/archive/${version}.tar.gz";
    hash = "sha256-3A1T+/iXhNeMS2Aww5jISoiNExdv9N9/kwyATSuwVTE=";
  };

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

  meta = with lib; {
    description = "Tool to submit code to Gerrit";
    homepage = "https://opendev.org/opendev/git-review";
    license = licenses.asl20;
    maintainers = with maintainers; [ metadark ];
  };
}
