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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-woYWWDJ2JeyghlRh5IKhPfDy4WmcAGlBJgjBPg1hHq8=";
  };

  cargoRoot = "backend";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-tyN9gM8U8kOl62Z0N/plcpTOCbOPuT0kkLI/EKLv/mQ=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-y+WZF30R/+nvAVr50SWmMN5kfVb1kYiylAd1IBftoVA=";
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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
