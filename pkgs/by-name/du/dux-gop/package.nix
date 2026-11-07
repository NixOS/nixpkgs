{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoLatestModule (finalAttrs: {
  pname = "dux-gop";
  version = "2.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duxlabs-dev";
    repo = "dux-gop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cIgKTjylOaShxgTedHywHi4Sk3bzSrooY+E2grlK3WU=";
  };

  vendorHash = "sha256-ajtmBCQ4OdIpjOQeiL+hj3e6PL2Np4NLnMAcA1AsW/w=";

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
    platforms = lib.platforms.linux;
  };
})
