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
  version = "4.8.6";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = "rssguard";
    tag = version;
    sha256 = "sha256-2gwzk23t9WRHrXlASzba9HQRijHjH0nfWsBjMcqgq68=";
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

  meta = {
    description = "Simple RSS/Atom feed reader with online synchronization";
    mainProgram = "rssguard";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
    changelog = "https://github.com/martinrotter/rssguard/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jluttine
      tebriel
    ];
  };
}
