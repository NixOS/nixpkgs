{
  lib,
  stdenv,
  fetchFromCodeberg,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  appstream-glib,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stockpile";
  version = "0.5.0";

  src = fetchFromCodeberg {
    owner = "turtle";
    repo = "stockpile";
    tag = finalAttrs.version;
    hash = "sha256-e8mBZyZFGtiDGsAb4kyNOzLNA9GIE6X8buRJj6DCbxM=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'rev-parse', '--short', 'HEAD').stdout().strip()" "'${finalAttrs.version}'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    vala
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  meta = {
    description = "Keep count of restockable items";
    homepage = "https://codeberg.org/turtle/stockpile";
    mainProgram = "stockpile";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
