{ stdenv, fetchgit, qmake, qtwebengine, qttools, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "rssguard-${version}";
  version = "3.4.0";

  src = fetchgit {
    url = https://github.com/martinrotter/rssguard;
    rev = "refs/tags/${version}";
    sha256 = "1cdpfjj2lm1q2qh0w0mh505blcmi4n78458d3z3c1zn9ls9b9zsp";
    fetchSubmodules = true;
  };

  buildInputs =  [ qtwebengine qttools ];
  nativeBuildInputs = [ qmake wrapGAppsHook ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with stdenv.lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = https://github.com/martinrotter/rssguard;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
