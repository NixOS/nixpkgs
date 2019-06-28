{ lib, fetchFromGitHub, buildPythonApplication, pyside2, shiboken2, twisted, certifi }:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.6.4a";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "0zz4a3vzfg808z1qkqz31z4818wzpfa2lika7wl0jgpmw4zi85ix";
  };

  propagatedBuildInputs = [ pyside2 shiboken2 twisted certifi ] ++ twisted.extras.tls;

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
