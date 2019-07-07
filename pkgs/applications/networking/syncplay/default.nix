{ lib, fetchFromGitHub, buildPythonApplication, pyside, twisted, certifi }:

buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.6.3";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "03xw44lxdk1h9kbvfviqzpmxxld6zvp07i0hvdm1chchyp0a109h";
  };

  propagatedBuildInputs = [ pyside twisted certifi ] ++ twisted.extras.tls;

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
