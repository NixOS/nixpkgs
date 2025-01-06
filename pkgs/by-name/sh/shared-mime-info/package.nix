{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gettext,
  libxml2,
  glib,
  shared-mime-info,
}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info";
  version = "2.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = pname;
    rev = version;
    hash = "sha256-5eyMkfSBUOD7p8woIYTgz5C/L8uQMXyr0fhL0l23VMA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) shared-mime-info;

  buildInputs = [
    libxml2
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dupdate-mimedb=true"
  ];

  meta = {
    description = "Database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = lib.teams.freedesktop.members ++ [ lib.maintainers.mimame ];
    mainProgram = "update-mime-database";
  };
}
