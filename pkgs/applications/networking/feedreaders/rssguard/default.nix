{ stdenv, fetchFromGitHub, qmake, qtwebengine, qttools, wrapGAppsHook, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = version;
    sha256 = "1l2ra06am6bgwb4q200lhi64sz3np1dzf2vpjh10znxbx0mahbq6";
  };

  buildInputs =  [ qtwebengine qttools ];
  nativeBuildInputs = [ qmake wrapGAppsHook wrapQtAppsHook ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with stdenv.lib; {
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
