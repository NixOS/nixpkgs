{ lib, fetchFromGitHub, buildPythonApplication, pyside2, shiboken2, twisted, certifi, qt5 }:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.6.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "1wkxdp7dv5y1100awy949higvs5035ylfyl83qrp4lnimy3imw09";
  };

  propagatedBuildInputs = [ pyside2 shiboken2 twisted certifi ] ++ twisted.extras.tls;
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  postFixup = ''
    wrapQtApp $out/bin/syncplay
  '';

  meta = with lib; {
    homepage = "https://syncplay.pl/";
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
