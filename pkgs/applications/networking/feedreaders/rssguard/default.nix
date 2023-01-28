{ lib, stdenv, fetchFromGitHub, cmake, qtwebengine, qttools, wrapGAppsHook, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.2.7";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = version;
    sha256 = "sha256-X5hZspl9IekhC8XXpZS285cmVZek2oxIV3tYOz/ZBec=";
  };

  buildInputs =  [ qtwebengine qttools ];
  nativeBuildInputs = [ cmake wrapGAppsHook wrapQtAppsHook ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
