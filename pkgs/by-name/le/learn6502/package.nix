{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs,
  meson,
  ninja,
  blueprint-compiler,
  gtksourceview5,
  wrapGAppsHook4,
  desktop-file-utils,
  pkg-config,
  writableTmpDirAsHomeHook,
  gjs,
  libadwaita,
  nix-update-script,
}:

let
  yarn-berry = yarn-berry_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "learn6502";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "JumpLink";
    repo = "Learn6502";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2c8dUhxCNaDlvQlYwqebfAAlClrnJpGFs9EukdiVgy0=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-nbahJ+nwpHVvw8pCqhg1W+4lmgSH7o7BjjhujF7yyQs=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    meson
    ninja
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
    pkg-config
    writableTmpDirAsHomeHook
    gjs # gjs-console
  ];

  buildInputs = [
    gjs
    gtksourceview5
    libadwaita
  ];

  strictDeps = true;

  # yarnBerryConfigHook needs to run in the yarn.lock directory
  postConfigure = ''
    pushd ..
  '';

  # meson needs to enter the subdirectory
  preBuild = ''
    popd
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern 6502 Assembly Learning Environment for GNOME";
    homepage = "https://github.com/JumpLink/Learn6502";
    mainProgram = "eu.jumplink.Learn6502";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
