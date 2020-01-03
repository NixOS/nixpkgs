{ stdenv, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication {
  pname = "protocol-unstable";
  version = "2019-03-28";

  src = fetchFromGitHub {
    owner = "luismartingarcia";
    repo = "protocol";
    rev = "4e8326ea6c2d288be5464c3a7d9398df468c0ada";
    sha256 = "13l10jhf4vghanmhh3pn91b2jdciispxy0qadz4n08blp85qn9cm";
  };

  meta = with stdenv.lib; {
    description = "An ASCII Header Generator for Network Protocols";
    homepage = https://github.com/luismartingarcia/protocol;
    license = licenses.gpl3;
    maintainers = with maintainers; [ teto ];
  };
}
