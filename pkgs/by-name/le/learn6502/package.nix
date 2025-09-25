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
  writeShellScript,
  nix-update,
}:

let
  yarn-berry = yarn-berry_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "learn6502";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "JumpLink";
    repo = "Learn6502";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aoj4Z9uraBEH3BW0hrhuV3Hu7cnRxvjbpzm4pUziWS4=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-0r+SRVx8b238SVm+XM4+uw7Ge3rFtsNwD/+uNfBA7eM=";
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

  passthru.updateScript = writeShellScript "update-learn6502" ''
    ${lib.getExe nix-update} learn6502 || true
    export HOME=$(mktemp -d)
    src=$(nix build --no-link --print-out-paths .#learn6502.src)
    WORKDIR=$(mktemp -d)
    cp --recursive --no-preserve=mode $src/* $WORKDIR
    missingHashes=$(nix eval --file . learn6502.missingHashes)
    pushd $WORKDIR
    ${lib.getExe yarn-berry.yarn-berry-fetcher} missing-hashes yarn.lock >$missingHashes
    popd
    ${lib.getExe nix-update} learn6502 --version skip
  '';

  meta = {
    description = "Modern 6502 Assembly Learning Environment for GNOME";
    homepage = "https://github.com/JumpLink/Learn6502";
    mainProgram = "eu.jumplink.Learn6502";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
})
