{
  buildNpmPackage,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  lib,
  makeDesktopItem,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "flightcore";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "R2NorthstarTools";
    repo = "FlightCore";
    # tag = "v${finalAttrs.version}";
    rev = "main";
    hash = "sha256-NnU7ywJlF8qsU1M7wzlJHc86+0QaiIR6JCdmraPfr68=";
  };

  # `source/package.json`
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+xrNKFcCatqbl79j/tSLFNTYjxXANFb3/vgWXYY2PGo=";
  };

  frontend = buildNpmPackage {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;
    sourceRoot = "source/src-vue";

    # `source/src-vue/package.json`
    npmDepsHash = "sha256-2PiMB9X/tp1QtTfUgVnH6caE+m2QSKTMYxPUHAUPWhQ=";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -a dist "$out"

      runHook postInstall
    '';
  };

  cargoHash = "sha256-ILsRsYHO1OMyfORxrUkr1jyjncLCGag+KefrWHmHpqQ=";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  # This override does the following:
  #
  # * Disables creating updater artifacts - the default behavior causes issues
  #   with building the package, but since it is going to be distributed via a
  #   software repository, it won't need to auto-update itself anyways.
  #
  # * Empties `beforeBuildCommand` - the upstream Tauri configuration includes
  #   commands that automatically build the software's front-end, before
  #   building its back-end. However, since Nixpkgs requires NPM dependencies
  #   to be hashed, we need to build the front-end in a separate step.
  #
  #   This way, we end up fetching the NPM dependencies from both
  #   `source/package.json`, and `source/src-vue/package.json`.
  tauriBuildFlags = "-c ${./override-tauri.conf.json}";

  # Copy [frontend] to where it can be picked up by Tauri.
  preBuild = ''
    cp -a "${finalAttrs.frontend}"/dist src-vue
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  desktopItem = makeDesktopItem {
    name = "FlightCore";
    desktopName = "FlightCore";
    exec = "flightcore";
    icon = "flightcore";
    comment = finalAttrs.meta.description;
    genericName = finalAttrs.meta.description;
    categories = [
      "Game"
      "Utility"
      "PackageManager"
    ];
    terminal = false;
  };

  meta = {
    description = "Updater and mod manager for Northstar";
    homepage = "https://github.com/R2NorthstarTools/FlightCore";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ username-generic ];
    mainProgram = "flightcore";
    platforms = [ "x86_64-linux" ];
  };
})
