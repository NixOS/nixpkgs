{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "dux-gop";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duxlabs-dev";
    repo = "dux-gop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GTDomQTBU132DVjqX/o3cZBo9ylUWLvUJ74PSlahgTo=";
  };

  vendorHash = "sha256-bVrNwxylrKkmDWdrw+G/yi3DgVdRZtOVn53HfmpXjJk=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dgop \
      --bash <($out/bin/dgop completion bash) \
      --fish <($out/bin/dgop completion fish) \
      --zsh <($out/bin/dgop completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "API & CLI for System & Process Monitoring";
    homepage = "https://github.com/duxlabs-dev/dux-gop";
    changelog = "https://github.com/duxlabs-dev/dux-gop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.duxlabs ];
    mainProgram = "dgop";
    platforms = lib.platforms.unix;
  };
})
