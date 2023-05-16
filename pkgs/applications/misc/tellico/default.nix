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
<<<<<<< HEAD
  version = "3.5.1";
=======
  version = "3.4.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-opg4FbfOM48eqWQUJnMHH7KSo6x4S2DHd7ucPw6iTzg=";
  };

=======
    hash = "sha256-aHA4DYuxh4vzXL82HRGMPfqS0DGqq/FLMEuhsr4eLko=";
  };

  postPatch = ''
    substituteInPlace src/gui/imagewidget.h \
      --replace ksane_version.h KF5/ksane_version.h
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
