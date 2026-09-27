{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gjs,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  webkitgtk_6_0,
  gtksourceview5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "playhouse";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Playhouse";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-3W4Hl1NTA39TGWDUMBvYXx+UhfzsRU+0WdCBL2Y3xyI=";
  };

  postPatch = ''
    patchShebangs --build troll/gjspack/bin/gjspack
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gjs
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gjs
    libadwaita
    webkitgtk_6_0
    gtksourceview5
  ];

  meta = {
    description = "Playground for HTML/CSS/JavaScript";
    homepage = "https://github.com/sonnyp/Playhouse";
    license = lib.licenses.gpl3Only;
    mainProgram = "re.sonny.Playhouse";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
