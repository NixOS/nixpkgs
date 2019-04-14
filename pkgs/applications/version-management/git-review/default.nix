{ stdenv, fetchurl, pythonPackages} :

pythonPackages.buildPythonApplication rec {
  name = "git-review-${version}";
  version = "1.28.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = "${version}";

  postPatch = ''
    sed -i -e '/argparse/d' requirements.txt
  '';

  src = fetchurl rec {
    url = "https://github.com/openstack-infra/git-review/archive/${version}.tar.gz";
    sha256 = "14k003n8n0rb56qqs9a5jl02kg9x9ziapviw1hn8cql5y6mxysv3";
  };

  propagatedBuildInputs = with pythonPackages; [ pbr requests setuptools ];

  # Don't do tests because they require gerrit which is not packaged
  doCheck = false;

  meta = {
    homepage = https://github.com/openstack-infra/git-review;
    description = "Tool to submit code to Gerrit";
    license = stdenv.lib.licenses.asl20;
  };
}
