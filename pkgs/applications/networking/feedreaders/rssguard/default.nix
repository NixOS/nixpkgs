{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  mpv,
  qt5compat,
  qtmultimedia,
  qttools,
  qtwebengine,
  wrapGAppsHook,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.6.6";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XjUjOXfxvC3iXKayYggKAp1n7diynpr11c7TKn7Uj4Q=";
  };

  buildInputs = [
    qt5compat
    qtmultimedia
    qttools
    qtwebengine
    mpv
  ];
  nativeBuildInputs = [
    cmake
    wrapGAppsHook
    wrapQtAppsHook
  ];
  qmakeFlags = [ "CONFIG+=release" ];

  meta = with lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    mainProgram = "rssguard";
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
