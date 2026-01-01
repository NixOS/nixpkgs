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
    repo = "shared-mime-info";
    rev = version;
    hash = "sha256-5eyMkfSBUOD7p8woIYTgz5C/L8uQMXyr0fhL0l23VMA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) shared-mime-info;

  buildInputs = [
    libxml2
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dupdate-mimedb=true"
  ];

<<<<<<< HEAD
  meta = {
    description = "Database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mimame ];
    teams = [ lib.teams.freedesktop ];
=======
  meta = with lib; {
    description = "Database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
    teams = [ teams.freedesktop ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "update-mime-database";
  };
}
