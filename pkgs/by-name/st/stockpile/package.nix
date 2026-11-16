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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stockpile";
  version = "0.5.1";

  src = fetchFromCodeberg {
    owner = "turtle";
    repo = "stockpile";
    tag = finalAttrs.version;
    hash = "sha256-6RYd1vhArdH4s68QOSIDVPQqX2w+Dsa8HLVxCKPzYWo=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keep count of restockable items";
    homepage = "https://codeberg.org/turtle/stockpile";
    mainProgram = "stockpile";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
