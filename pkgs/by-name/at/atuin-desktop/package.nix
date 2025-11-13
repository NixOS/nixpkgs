{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  wrapGAppsHook4,
  nix-update-script,

  cargo-tauri,
  nodejs,
  pkg-config,
  pnpm,

  glib-networking,
  libappindicator-gtk3,
  openssl,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin-desktop";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ySws3R4CatOrKjjGrLJQU9feXIb5MdVX1uKK0fFV21s=";
  };

  cargoRoot = "backend";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-gyDg8XBPiMovOtzmb0eHVWuXmavZTBMvPPgbcdNU6xo=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-6YDYrFo5iCelRGBnDFoI8V3Nv/8w3XPNwuArc+nSShU=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpm.configHook

    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libappindicator-gtk3
    openssl
    webkitgtk_4_1
  ];

  env = {
    # Used upstream: https://github.com/atuinsh/desktop/blob/2f9a90963c4a6299bf35d8a49b0a2ffb8a28ee32/.envrc.
    NODE_OPTIONS = "--max-old-space-size=5120";
  };

  # Otherwise tauri will look for a private key we don't have.
  tauriConf = builtins.toJSON { bundle.createUpdaterArtifacts = false; };
  passAsFile = [ "tauriConf" ];
  preBuild = ''
    npm rebuild ts-tiny-activerecord
    tauriBuildFlags+=(
      "--config"
      "$tauriConfPath"
    )
  '';

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    # Failing for unknown reason.
    "--skip=runtime::blocks::handlers::script_output_test::tests::test_multiple_scripts"
  ];
  doCheck = !stdenv.isDarwin;

  meta = {
    description = "Local-first, executable runbook editor";
    homepage = "https://atuin.sh";
    downloadPage = "https://github.com/atuinsh/desktop";
    changelog = "https://github.com/atuinsh/desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adda
      dzervas
      randoneering
    ];
    mainProgram = "atuin-desktop";
    platforms = with lib.platforms; windows ++ darwin ++ linux;
  };
})
