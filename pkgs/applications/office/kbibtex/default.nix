{ lib
, mkDerivation
, fetchurl
# build-time
, extra-cmake-modules
, shared-mime-info
# Qt
, qtnetworkauth
, qtxmlpatterns
, qtwebengine
, qca-qt5
# KDE
, ki18n
, kxmlgui
, kio
, kiconthemes
, kitemviews
, kparts
, kcoreaddons
, kservice
, ktexteditor
, kdoctools
, kwallet
, kcrash
# other
, poppler
, bibutils
}:

mkDerivation rec {
  pname = "kbibtex";
  version = "0.9.3.1";

  src = let
    majorMinorPatch = lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version));
  in fetchurl {
    url = "mirror://kde/stable/KBibTeX/${majorMinorPatch}/kbibtex-${version}.tar.xz";
    hash = "sha256-kH/E5xv9dmzM7WrIMlGCo4y0Xv/7XHowELJP3OJz8kQ=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];

  buildInputs = [
    qtnetworkauth
    qtxmlpatterns
    qtwebengine
    qca-qt5
    # TODO qtoauth
    ki18n
    kxmlgui
    kio
    kiconthemes
    kitemviews
    kparts
    kcoreaddons
    kservice
    ktexteditor
    kdoctools
    kwallet
    kcrash
    poppler
  ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ bibutils ]}"
  ];

  meta = with lib; {
    description = "Bibliography editor for KDE";
    homepage = "https://userbase.kde.org/KBibTeX";
    changelog = "https://invent.kde.org/office/kbibtex/-/raw/v${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
