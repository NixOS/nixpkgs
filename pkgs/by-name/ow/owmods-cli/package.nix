{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  installShellFiles,
  zstd,
  libsoup_3,
  makeWrapper,
  mono,
  wrapWithMono ? true,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "owmods-cli";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "ow-mods";
    repo = "ow-mod-man";
    rev = "cli_v${finalAttrs.version}";
    hash = "sha256-8ZHLb57/gC03+rWe8mHcBS0nJVNjjRMtLADwGcSZ0CI=";
  };

  cargoHash = "sha256-WxfbkfOXU1NgUYagsDu3ri26k+XytG7Vy8+ofuQEwjE=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ]
  ++ lib.optional wrapWithMono makeWrapper;

  buildInputs = [
    zstd
    libsoup_3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildAndTestSubdir = "owmods_cli";

  postInstall = ''
    cargo xtask dist_cli
    installManPage dist/cli/man/*
    installShellCompletion --cmd owmods \
    dist/cli/completions/owmods.{bash,fish,zsh}
  ''
  + lib.optionalString wrapWithMono ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} --prefix PATH : '${mono}/bin'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_cli";
    downloadPage = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${finalAttrs.version}";
    changelog = "https://github.com/ow-mods/ow-mod-man/releases/tag/cli_v${finalAttrs.version}";
    mainProgram = "owmods";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bwc9876
      spoonbaker
      locochoco
    ];
  };
})
