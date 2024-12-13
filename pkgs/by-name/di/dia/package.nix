{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  dblatex,
  desktop-file-utils,
  graphene,
  gtk3,
  gtk-mac-integration-gtk3,
  intltool,
  libxml2,
  libxslt,
  meson,
  ninja,
  pkg-config,
  poppler,
  python3,
  wrapGAppsHook3,
  # Building with docs are still failing in unstable-2023-09-28
  withDocs ? false,
}:

stdenv.mkDerivation {
  pname = "dia";
  version = "unstable-2023-09-28";

  src = fetchFromGitLab {
    owner = "GNOME";
    repo = "dia";
    domain = "gitlab.gnome.org";
    rev = "bd551bb2558dcc89bc0bf7b4dd85b38cd85ad322";
    hash = "sha256-U+8TUE1ULt6MNxnvw9kFjCAVBecUy2Sarof6H9+kR7Q=";
  };

  # Required for the PDF plugin when building with clang.
  CXXFLAGS = "-std=c++17";

  preConfigure = ''
    patchShebangs .
  '';

  buildInputs =
    [
      graphene
      gtk3
      libxml2
      python3
      poppler
    ]
    ++ lib.optionals withDocs [
      libxslt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      gtk-mac-integration-gtk3
    ];

  nativeBuildInputs =
    [
      appstream-glib
      desktop-file-utils
      intltool
      meson
      ninja
      pkg-config
      wrapGAppsHook3
    ]
    ++ lib.optionals withDocs [
      dblatex
    ];

  meta = with lib; {
    description = "Gnome Diagram drawing software";
    mainProgram = "dia";
    homepage = "http://live.gnome.org/Dia";
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
