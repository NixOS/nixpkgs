{ stdenv, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "protocol";
  version = "20171226";

  src = fetchFromGitHub {
    owner = "luismartingarcia";
    repo = "protocol";
    rev = "d450da7d8a58595d8ef82f1d199a80411029fc7d";
    sha256 = "1g31s2xx0bw8ak5ag1c6mv0p0b8bj5dp3lkk9mxaf2ndj1m1qdkw";
  };

  meta = with stdenv.lib; {
    description = "An ASCII Header Generator for Network Protocols";
    homepage = https://github.com/luismartingarcia/protocol;
    license = licenses.gpl3;
    maintainers = with maintainers; [ teto ];
  };
}
