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

stdenv.mkDerivation (finalAttrs: {
  pname = "annotator";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "annotator";
    tag = finalAttrs.version;
    hash = "sha256-mv3fMlYB4XcAWI6O6wN8ujNRDLZlX3ef/gKdOMYEHq0=";
  };

  postPatch = ''
    substituteInPlace src/Application.vala \
      --replace-fail 'Environment.set_variable( "GDK_BACKEND", "x11", true );' ""
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libgee
    pantheon.granite7
    libportal-gtk4
    libxml2
    libhandy
    gtk3
  ];

  meta = {
    description = "Image annotation for Elementary OS";
    homepage = "https://github.com/phase1geo/Annotator";
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.phase1geo.annotator";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
