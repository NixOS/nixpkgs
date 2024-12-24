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
  version = "24.14";

  src = fetchFromGitHub {
    owner = "toolstack";
    repo = "Folio";
    rev = "refs/tags/${version}";
    hash = "sha256-A0vUM6oIchpC/1NEjPmZkT2/f/CmEWmPsMHQrGkDKXQ=";
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
