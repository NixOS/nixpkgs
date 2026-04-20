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

stdenv.mkDerivation (finalAttrs: {
  pname = "folio";
  version = "26.01";

  src = fetchFromGitHub {
    owner = "toolstack";
    repo = "Folio";
    tag = finalAttrs.version;
    hash = "sha256-ctBLTGJ0cixqHHOrHmkN1+NyuVr6dcNNtVmquGgMdWE=";
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
})
