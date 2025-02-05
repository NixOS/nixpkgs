{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  libgee,
  gtksourceview5,
}:

stdenv.mkDerivation rec {
  pname = "folio";
  version = "25.01";

  src = fetchFromGitHub {
    owner = "toolstack";
    repo = "Folio";
    tag = version;
    hash = "sha256-EfZMHoF6xyRaxrLDLkBb07fvUxSQFDFViQJ2y68YhZg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libgee
    gtksourceview5
  ];

  meta = {
    description = "Beautiful markdown note-taking app for GNOME (forked from Paper)";
    homepage = "https://github.com/toolstack/Folio";
    license = lib.licenses.gpl3Only;
    mainProgram = "com.toolstack.Folio";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
