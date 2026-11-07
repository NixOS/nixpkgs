{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule {
  pname = "packwiz";
  version = "0-unstable-2026-10-14";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "170b22d785959dda5876b54b7f16e1b807a57fb6";
    sha256 = "sha256-GGOa5GtoeFNgGzZ4lrNDIp8NHxk9P9P6bze+c2FQC8M=";
  };
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  vendorHash = "sha256-qvRlOxxvHffnsXy4MhbGIBGCDPtok/ymS/sUAJ5sGR0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd packwiz \
      --bash <($out/bin/packwiz completion bash) \
      --fish <($out/bin/packwiz completion fish) \
      --zsh <($out/bin/packwiz completion zsh)
  '';

  meta = {
    description = "Command line tool for editing and distributing Minecraft modpacks, using a git-friendly TOML format";
    homepage = "https://packwiz.infra.link/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      infinidoge
      bddvlpr
    ];
    mainProgram = "packwiz";
  };
}
