{ stdenv, fetchFromGitHub, python2Packages} :

python2Packages.buildPythonApplication rec {
  pname = "git-review";
  version = "1.28.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = "${version}";

  src = fetchFromGitHub rec {
    owner = "openstack-infra";
    repo = pname;
    rev = version;
    sha256 = "1hgw1dkl94m3idv4izc7wf2j7al2c7nnsqywy7g53nzkv9pfv47s";
  };

  propagatedBuildInputs = with python2Packages; [ pbr requests setuptools ];

  # Don't do tests because they require gerrit which is not packaged
  doCheck = false;

  meta = {
    homepage = https://github.com/openstack-infra/git-review;
    description = "Tool to submit code to Gerrit";
    license = stdenv.lib.licenses.asl20;
  };
}
