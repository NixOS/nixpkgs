{
  lib,
  stdenv,
  fetchFromGitLab,
  mkDerivation,
  cmake,
  exempi,
  extra-cmake-modules,
  karchive,
  kdoctools,
  kfilemetadata,
  khtml,
  kitemmodels,
  knewstuff,
  kxmlgui,
  libcdio,
  libkcddb,
  libksane,
  makeWrapper,
  poppler,
  qtcharts,
  qtwebengine,
  solid,
  taglib,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "tellico";
  version = "4.0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5oP/uGUw1oYnrnOU83Pocr9YdwAU+DaUaGHg+6NzmRU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    exempi
    karchive
    kfilemetadata
    khtml
    kitemmodels
    knewstuff
    kxmlgui
    libcdio
    libkcddb
    libksane
    poppler
    qtcharts
    qtwebengine
    solid
    taglib
  ];

  meta = with lib; {
    description = "Collection management software, free and simple";
    mainProgram = "tellico";
    homepage = "https://tellico-project.org/";
    license = with licenses; [
      gpl2Only
      gpl3Only
      lgpl2Only
    ];
    maintainers = with maintainers; [ numkem ];
    platforms = platforms.linux;
  };
}
