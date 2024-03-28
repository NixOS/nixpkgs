{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  mpv,
  qt6,
  wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.6.6";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-XjUjOXfxvC3iXKayYggKAp1n7diynpr11c7TKn7Uj4Q=";
  };

  buildInputs = with qt6; [
    qtwebengine
    qttools
    qtmultimedia
    qt5compat
    mpv
  ];
  nativeBuildInputs = [ cmake wrapGAppsHook qt6.wrapQtAppsHook ];
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
