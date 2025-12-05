{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  exempi,
  extra-cmake-modules,
  karchive,
  kdoctools,
  kfilemetadata,
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
  version = "4.1.4";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "tellico";
    rev = "v${version}";
    hash = "sha256-eScAOd1da05fqXtbcz8oEJiObB7CUxiYReSrr3R7ybM=";
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
