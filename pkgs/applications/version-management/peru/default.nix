{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "peru-${version}";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = "${version}";
    sha256 = "0mzmi797f2h2wy36q4ab701ixl5zy4m0pp1wp9abwdfg2y6qhmnk";
  };

  propagatedBuildInputs = with python3Packages; [ pyyaml docopt ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/buildinspace/peru;
    description = "A tool for including other people's code in your projects";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
