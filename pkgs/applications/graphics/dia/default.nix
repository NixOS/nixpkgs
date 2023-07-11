{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, cmake
, dblatex
, desktop-file-utils
, graphene
, gtk2
, gtk-mac-integration-gtk2
, intltool
, libxml2
, libxslt
, meson
, ninja
, pkg-config
, poppler
, python3
  # Building with docs are failing in unstable-2022-12-14
, withDocs ? false
}:

stdenv.mkDerivation {
  pname = "dia";
  version = "unstable-2022-12-14";

  src = fetchFromGitLab {
    owner = "GNOME";
    repo = "dia";
    domain = "gitlab.gnome.org";
    rev = "4a619ec7cc93be5ddfbcc48d9e1572d04943bcad";
    hash = "sha256-xi45Ak4rlDQjs/FNkdkm145mx76GNHjE6Nrs1dc94ww=";
  };

  patches = [ ./poppler-22_09-build-fix.patch ];

  # Required for the PDF plugin when building with clang.
  CXXFLAGS = "-std=c++17";

  preConfigure = ''
    patchShebangs .
  '';

  buildInputs = [
    graphene
    gtk2
    libxml2
    python3
    poppler
  ] ++
  lib.optionals withDocs [
    libxslt
  ] ++
  lib.optionals stdenv.isDarwin [
    gtk-mac-integration-gtk2
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    intltool
    meson
    ninja
    pkg-config
  ] ++
  lib.optionals withDocs [
    dblatex
  ];

  meta = with lib; {
    description = "Gnome Diagram drawing software";
    homepage = "http://live.gnome.org/Dia";
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
