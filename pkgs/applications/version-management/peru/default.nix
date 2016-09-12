{ stdenv, fetchurl, python3Packages }:

let 
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {

  name = "peru-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://pypi/p/peru/${name}.tar.gz";
    sha256 = "d51771d4aa7e16119e46c39efd71b0a1a898607bf3fb7735fc688a64fc59cbf1";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml docopt ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = https://github.com/buildinspace/peru;
    description = "A tool for including other people's code in your projects";
    license = stdenv.lib.licenses.mit;
  };
}