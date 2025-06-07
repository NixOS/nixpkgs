{
  stdenv,
  fetchFromGitLab,
  lib,
  extra-cmake-modules,
  kdePackages,
  taglib,
  exiv2,
  podofo010,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "krename";
  version = "5.0.60-unstable-f72db95";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "krename";
    rev = "f72db95c1394d3c9360ffd1ed37c1b8f5772cfdd";
    sha256 = "sha256-6fcNaBzHgIWNWw1znCykmxOqv6ZBzecT2KQEyEaVSbI=";
  };

  buildInputs = with kdePackages; [
    exiv2
    podofo010
    taglib
    kio
    kxmlgui
    qtbase
    qtdeclarative
    qt5compat
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdePackages.kdoctools
    kdePackages.wrapQtAppsHook
  ];

  NIX_LDFLAGS = "-ltag";

  meta = {
    description = "Powerful batch renamer for KDE";
    mainProgram = "krename";
    homepage = "https://kde.org/applications/utilities/krename/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      peterhoeg
      kuflierl
    ];
    inherit (kdePackages.qtbase.meta) platforms;
  };
})
