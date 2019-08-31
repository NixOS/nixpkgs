{ lib, fetchFromGitHub, buildPythonApplication, pyside, twisted, certifi }:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.6.4";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "0afh2a0l1c3hwgj5q6wy0v5iimg8qcjam3pw7b8mf63lasx6iqk4";
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
