{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  nodejs,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  glib-networking,
  libsoup_3,
  librsvg,
  libsecret,
  openssl,
  dbus,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paperlines";
  version = "0.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Paperlines";
    repo = "paperlines";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0s6pA7B6RdBQ706quMzZ8eXQUvLclDpPZlAE1bYgFYY=";
  };

  cargoHash = "sha256-QCg59o1aRwjWme1TPVbR8GJ66b8hPxjLgiMXpJOoNmI=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-1guHda1uUFCS4notWsOpn/rsMQMJ0d1sTFm2UHC9SfE=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    glib-networking
    libsoup_3
    librsvg
    libsecret
    openssl
    dbus
    sqlite
  ];

  env = {
    # package.json pins pnpm and Node for contributors; use nixpkgs' own in the sandbox
    npm_config_manage_package_manager_versions = "false";
    npm_config_engine_strict = "false";
    COREPACK_ENABLE_STRICT = "0";
  };

  # the Tauri crate is in src-tauri; the Cargo workspace and lockfile are at the root
  buildAndTestSubdir = "src-tauri";

  # name the desktop entry after the app ID, which is also the Wayland app ID, so docks match
  # the window to its launcher and icon
  postInstall = ''
    for f in $out/share/applications/*.desktop; do
      [ "$f" = "$out/share/applications/dev.example.paperlines.desktop" ] \
        || mv "$f" "$out/share/applications/dev.example.paperlines.desktop"
    done
  '';

  # lets nixpkgs' update bot (r-ryantm) and `nix-update` refresh the version and all three hashes
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first reference manager with a citation graph, PDF annotations and linked notes";
    longDescription = ''
      Paperlines keeps papers, their PDFs, Markdown notes with links and formulas, and a graph of
      how papers cite each other in one local library, with no account or cloud. It includes the
      `paperlines` command-line tool and an MCP server for AI assistants.
    '';
    homepage = "https://github.com/Paperlines/paperlines";
    changelog = "https://github.com/Paperlines/paperlines/blob/v${finalAttrs.version}/docs/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ yoav-yosifor ];
    mainProgram = "paperlines-app";
    platforms = lib.platforms.linux;
  };
})
