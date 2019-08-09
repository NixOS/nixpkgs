{ stdenv, buildPythonApplication, fetchFromGitHub, matplotlib, procps, pyqt5
, sphinx
}:

buildPythonApplication rec {
  pname = "flent";
  version = "1.2.2";
  src = fetchFromGitHub {
    owner = "tohojo";
    repo = "flent";
    rev = "v${version}";
    sha256 = "1llcdakk0nk9xlpjjz7mv4a80yq4sjnbqhaqvyj9m6lbcxgssh2r";
  };

  buildInputs = [ sphinx ];

  checkInputs = [ procps ];

  propagatedBuildInputs = [
    matplotlib
    procps
    pyqt5
  ];

  meta = with stdenv.lib; {
    description = "The FLExible Network Tester";
    homepage = https://flent.org;
    license = licenses.gpl3;

    maintainers = [ maintainers.mmlb ];
  };
}
