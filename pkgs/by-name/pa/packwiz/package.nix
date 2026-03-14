{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "packwiz";
  version = "0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "52b123018f9e19b49703f76e78ad415642acf5c5";
    sha256 = "sha256-EVs2PngdapCUSf6J946rpJWnEbM8TtlDQQS/Zg16Qfs=";
  };
  passthru.updateScript = unstableGitUpdater { };

  vendorHash = "sha256-P1SsvHTYKUoPve9m1rloBfMxUNcDKr/YYU4dr4vZbTE=";

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
    maintainers = with lib.maintainers; [ infinidoge ];
    mainProgram = "packwiz";
  };
}
