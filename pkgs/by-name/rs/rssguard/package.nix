{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "rssguard";
  version = "4.8.4";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = "rssguard";
    tag = version;
    sha256 = "sha256-CWRsuIvjgQHnCfHVUvellFLma8vvqoROfPjKOIuCSCI=";
  };

  buildInputs = [
    kdePackages.qtwebengine
    kdePackages.qttools
    kdePackages.mpvqt
    kdePackages.full
  ];
  nativeBuildInputs = [
    cmake
    wrapGAppsHook4
    kdePackages.wrapQtAppsHook
  ];
  cmakeFlags = with lib; [
    (cmakeFeature "CMAKE_BUILD_TYPE" "\"Release\"")
  ];

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
    maintainers = with maintainers; [
      jluttine
      tebriel
    ];
  };
}
