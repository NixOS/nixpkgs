{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtwebengine
, qttools
, wrapGAppsHook
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.5.3";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-eF0jPT0gQnnBWu9IKfY0DwMwotL3IEjovqnQqx9v2NA=";
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
    changelog = "https://github.com/martinrotter/rssguard/releases/tag/${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
