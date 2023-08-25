{ lib
, fetchFromGitLab
, mkDerivation
, cmake
, exempi
, extra-cmake-modules
, karchive
, kdoctools
, kfilemetadata
, khtml
, kitemmodels
, knewstuff
, kxmlgui
, libcdio
, libkcddb
, libksane
, makeWrapper
, poppler
, qtcharts
, qtwebengine
, solid
, taglib
}:

mkDerivation rec {
  pname = "tellico";
  version = "3.5.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-opg4FbfOM48eqWQUJnMHH7KSo6x4S2DHd7ucPw6iTzg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    makeWrapper
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
    homepage = "https://tellico-project.org/";
    license = with licenses; [ gpl2Only gpl3Only lgpl2Only ];
    maintainers = with maintainers; [ numkem ];
    platforms = platforms.linux;
  };
}
