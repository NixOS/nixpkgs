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
  version = "0-unstable-2026-02-18";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "dfd8b68a4796c763e25bad50265ea1f1233e24f1";
    sha256 = "sha256-QK8sY7e6QHhg+GH8NiiePGFlsQBI0jjUlsgBuq1Yopc=";
  };
  passthru.updateScript = unstableGitUpdater { };

  vendorHash = "sha256-ChUE4hWl+UyPpbzK0GbJTD0AoBCogI7qGstga4+WujI=";

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
