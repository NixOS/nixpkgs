{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "peru";
  version = "1.2.0";

  disabled = python3Packages.pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = "${version}";
    sha256 = "0p4j51m89glx12cd65lcnbwpvin0v49wkhrx06755skr7v37pm2a";
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
