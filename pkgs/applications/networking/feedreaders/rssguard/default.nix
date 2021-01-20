{ lib, stdenv, fetchFromGitHub, qmake, qtwebengine, qttools, wrapGAppsHook, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "3.8.3";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = version;
    sha256 = "1704nj77h6s88l4by3wxl5l770gaig90mv3ix80r00nh8mhzq44q";
  };

  buildInputs =  [ qtwebengine qttools ];
  nativeBuildInputs = [ qmake wrapGAppsHook wrapQtAppsHook ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
