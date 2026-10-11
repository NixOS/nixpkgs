{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microclaw";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microclaw";
    repo = "microclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hFk9J7dtReUD9e/ZDgMLOzCPLZFdIoZXHRH/JPEtsN8=";
  };

  # The workspace lockfile pins Git revisions of GPUI/Zed crates used by the
  # optional desktop app. fetchCargoVendor vendors them behind this one hash.
  cargoHash = "sha256-IA4/7pE4bJed4SnNcG4mli1CgaSOa03+8yINa9ffwWo=";

  # Only the server binary is packaged; skip the GPUI desktop crates.
  cargoBuildFlags = [
    "--package"
    "microclaw"
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = "${finalAttrs.src}/web";
    hash = "sha256-4FxmBQnr9YlU/zjE3U1bBYwMtNdB/0ElEqGUoNCSt8k=";
  };
  npmRoot = "web";

  nativeBuildInputs = [
    pkg-config
    nodejs
    npmHooks.npmConfigHook
  ];

  # rusqlite and sqlite-vec compile their bundled SQLite; only OpenSSL is linked.
  buildInputs = [ openssl ];

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [
    "journald"
    "sqlite-vec"
  ];

  # build.rs embeds web/dist into the binary. Build the bundle from the
  # offline npm cache first and stop build.rs from running npm on its own.
  preBuild = ''
    npm --prefix web run build
  '';
  env.MICROCLAW_SKIP_WEB_BUILD = "1";

  cargoTestFlags = finalAttrs.cargoBuildFlags;
  checkFlags = [
    # Resolves api.openai.com through DNS; the build sandbox has no network.
    "--skip=media_client_accepts_public_https"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-channel agent runtime for Telegram, Discord, Slack, Feishu, and Web";
    homepage = "https://github.com/microclaw/microclaw";
    changelog = "https://github.com/microclaw/microclaw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "microclaw";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ everettjf ];
  };
})
