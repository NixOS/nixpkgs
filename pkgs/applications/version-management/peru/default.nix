{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "peru-${version}";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = "${version}";
    sha256 = "02kr3ib3ppbmcsjy8i8z41vp9gw9gdivy2l5aps12lmaa3rc6727";
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
