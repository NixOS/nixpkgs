{ lib, fetchFromGitHub, buildPythonApplication, pyside2, shiboken2, twisted, certifi, qt5 }:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.6.9";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "0qm3qn4a1nahhs7q81liz514n9blsi107g9s9xfw2i8pzi7v9v0v";
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
