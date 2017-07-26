{ stdenv, fetchurl, pythonPackages, python} :

pythonPackages.buildPythonApplication rec {
  name = "git-review-${version}";
  version = "1.25.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = "${version}";

  src = fetchurl rec {
    url = "https://github.com/openstack-infra/git-review/archive/${version}.tar.gz";
    sha256 = "aa594690ed586041a524d6e5ae76152cbd53d4f03a98b20b213d15cecbe128ce";
  };

  propagatedBuildInputs = [ pythonPackages.pbr pythonPackages.requests pythonPackages.argparse pythonPackages.setuptools ];

  # Don't do tests because they require gerrit which is not packaged
  doCheck = false;

  meta = {
    homepage = "https://github.com/openstack-infra/git-review";
    description = "Tool to submit code to Gerrit";
    license = stdenv.lib.licenses.asl20;
  };
}
