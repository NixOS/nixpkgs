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
  version = "0-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "241f24b550f6fe838913a56bdd58bac2fc53254a";
    sha256 = "sha256-VmNsWzsFVNRciNIPUXUVos4cBdpawgN1/nPwMjNpx+0=";
  };
  passthru.updateScript = unstableGitUpdater { };

  vendorHash = "sha256-krdrLQHM///dtdlfEhvSUDV2QljvxFc2ouMVQVhN7A0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd packwiz \
      --bash <($out/bin/packwiz completion bash) \
      --fish <($out/bin/packwiz completion fish) \
      --zsh <($out/bin/packwiz completion zsh)
  '';

  meta = with lib; {
    description = "Command line tool for editing and distributing Minecraft modpacks, using a git-friendly TOML format";
    homepage = "https://packwiz.infra.link/";
    license = licenses.mit;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "packwiz";
  };
}
