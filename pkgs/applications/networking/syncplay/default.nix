{ lib, fetchFromGitHub, buildPythonApplication, pyside2, shiboken2, twisted, certifi, qt5 }:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.6.7";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "1hxmd13sff51lh9l3vpk33qrzf7gi58c76bc01iqimp17sxwfz3k";
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
