{ lib, fetchurl, buildPythonApplication, pbr, requests, setuptools }:

buildPythonApplication rec {
  pname = "git-review";
  version = "2.0.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = version;

  src = fetchurl {
    url = "https://opendev.org/opendev/${pname}/archive/${version}.tar.gz";
    sha256 = "0dkyd5g2xmvsa114is3cd9qmki3hi6c06wjnra0f4xq3aqm0ajnj";
  };

  propagatedBuildInputs = [ pbr requests setuptools ];

  # Don't do tests because they require gerrit which is not packaged
  doCheck = false;

  meta = with lib; {
    homepage = "https://opendev.org/opendev/git-review";
    description = "Tool to submit code to Gerrit";
    license = licenses.asl20;
    maintainers = with maintainers; [ metadark ];
  };
}
