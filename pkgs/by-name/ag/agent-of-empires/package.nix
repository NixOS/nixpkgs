{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  cmake,
  git,
  openssl,
  zlib,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-of-empires";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "njbrake";
    repo = "agent-of-empires";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MSvvGYvSi0dc7CAUI9ComAerptq8uEdE//3f03tC7S0=";
  };

  cargoHash = "sha256-wW8mnEUJ3LyzkeBFP3qdfwpuPsqIZmLOxi/lGIj5On8=";

  cargoBuildFlags = [ "--package" "agent-of-empires" ];
  cargoTestFlags = [ "--package" "agent-of-empires" ];

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    zlib
  ];

  nativeCheckInputs = [
    git
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd aoe \
      --bash <($out/bin/aoe completion bash) \
      --fish <($out/bin/aoe completion fish) \
      --zsh <($out/bin/aoe completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal session manager for AI coding agents";
    homepage = "https://github.com/njbrake/agent-of-empires";
    changelog = "https://github.com/njbrake/agent-of-empires/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "aoe";
  };
})
