{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  libgit2,
  openssl,
  zlib,
  stdenv,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-of-empires";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "njbrake";
    repo = "agent-of-empires";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ksxRr0PNAs15JjzgI5IzFQvsL9bY+4fPUUVpIhjDBEk=";
  };

  cargoHash = "sha256-rBDW2ZUgFegX6bhuOR3m9p/H74WDg+w85OmS01cw33o=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  nativeCheckInputs = [ git ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env.OPENSSL_NO_VENDOR = 1;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd aoe \
      --bash <($out/bin/aoe completion bash) \
      --fish <($out/bin/aoe completion fish) \
      --zsh <($out/bin/aoe completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal session manager for AI coding agents, built on tmux";
    homepage = "https://github.com/njbrake/agent-of-empires";
    changelog = "https://github.com/njbrake/agent-of-empires/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdw2 ];
    mainProgram = "aoe";
    platforms = lib.platforms.unix;
  };
})
