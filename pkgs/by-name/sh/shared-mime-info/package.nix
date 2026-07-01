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
let
  # Upstream doesn't pin the version of `xdgmime` in their git repository,
  # so it has to be fetched separately.
  xdgmime = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "xdgmime";
    rev = "04ce4cd90cb3fa77d5348662de221a6f33b21b17";
    hash = "sha256-0sjH6qG0RYb1kCw4+veTpzv1zJCzoTd2LPa9pqsZrgY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shared-mime-info";
  version = "2.5.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "shared-mime-info";
    tag = finalAttrs.version;
    hash = "sha256-FZFrsCYRyLSFWSOlAt+f6jUEVNy52plhEytu+0tFFvU=";
  };

  postPatch = ''
    ln -s ${xdgmime} subprojects/xdgmime
  '';

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
    "-Dbuild-spec=false"
  ];

  meta = {
    description = "Database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mimame ];
    teams = [ lib.teams.freedesktop ];
    mainProgram = "update-mime-database";
  };
})
