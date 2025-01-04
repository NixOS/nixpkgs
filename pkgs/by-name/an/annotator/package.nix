{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vala,
  wrapGAppsHook4,
  desktop-file-utils,
  gtk3,
  libgee,
  pantheon,
  libxml2,
  libhandy,
  libportal-gtk4,
}:

stdenv.mkDerivation rec {
  pname = "annotator";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "annotator";
    rev = version;
    hash = "sha256-mv3fMlYB4XcAWI6O6wN8ujNRDLZlX3ef/gKdOMYEHq0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    libgee
    pantheon.granite7
    libxml2
    libportal-gtk4
    libhandy
  ];

  meta = with lib; {
    description = "Image annotation for Elementary OS";
    homepage = "https://github.com/phase1geo/Annotator";
    license = licenses.gpl3Plus;
    mainProgram = "com.github.phase1geo.annotator";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
