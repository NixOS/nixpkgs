{ lib
, mkDerivation
, fetchurl
# build-time
, extra-cmake-modules
, shared-mime-info
# Qt
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
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://kde/stable/KBibTeX/${version}/kbibtex-${version}.tar.xz";
    sha256 = "09xcdx363z9hps3wbr1kx96a6q6678y8pg8r3apyps4xm7xm31nr";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];

  buildInputs = [
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
