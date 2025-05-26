{
  buildGoModule,
  dependabot-cli,
  dockerTools,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  symlinkJoin,
  testers,
}:
let
  pname = "dependabot-cli";
  version = "1.64.0";

  # vv Also update this vv
  tag = "nixpkgs-dependabot-cli-${version}";

  updateJobProxy = dockerTools.pullImage {
    imageName = "ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy";
    # Get these hashes from
    # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy --image-tag latest --final-image-name dependabot-update-job-proxy --final-image-tag ${tag}
    imageDigest = "sha256:3030ba5ff8f556e47016fca94d81c677b5c6abde99fef228341e1537588e503a";
    hash = "sha256-RiXUae5ONScoDu85L6BEf3T4JodBYha6v+d9kWl8oWc=";

    # Don't update this, it's used to refer to the imported image later
    finalImageName = "dependabot-update-job-proxy";
    finalImageTag = tag;
  };

  updaterGitHubActions = dockerTools.pullImage {
    imageName = "ghcr.io/dependabot/dependabot-updater-github-actions";
    # Get these hashes from
    # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/dependabot/dependabot-updater-github-actions --image-tag latest --final-image-name dependabot-updater-github-actions --final-image-tag ${tag}
    imageDigest = "sha256:a356576adbec11bc34b142b6ef69a5856a09dc3654bdc9f9b046c08ee2d73ff8";
    hash = "sha256-zqydb2v39xiSBT5ayWEacD0NIH6LoFX8lkRcCKppH08=";

    # Don't update this, it's used to refer to the imported image later
    finalImageName = "dependabot-updater-github-actions";
    finalImageTag = tag;
  };
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-NcmDYCXdhMY1KFz3if0XlX4EisQFr0YhJItllXnOfaA=";
  };

  vendorHash = "sha256-pnB1SkuEGm0KfkDfjnoff5fZRsAgD5w2H4UwsD3Jlbo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=v${version}"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd dependabot \
      --bash <($out/bin/dependabot completion bash) \
      --fish <($out/bin/dependabot completion fish) \
      --zsh <($out/bin/dependabot completion zsh)
  '';

  checkFlags = [
    "-skip=TestDependabot"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dependabot --help
  '';

  passthru.updateScript = ./update.sh;

  passthru.withDockerImages = symlinkJoin {
    name = "dependabot-cli-with-docker-images";
    paths = [ dependabot-cli ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      # Create a wrapper that pins the docker images that are depended upon
      wrapProgram $out/bin/dependabot \
        --run "docker load --input ${updateJobProxy} >&2" \
        --add-flags "--proxy-image=dependabot-update-job-proxy:${tag}" \
        --run "docker load --input ${updaterGitHubActions} >&2" \
        --add-flags "--updater-image=dependabot-updater-github-actions:${tag}"
    '';
  };

  passthru.tests.version = testers.testVersion {
    package = dependabot-cli;
    command = "dependabot --version";
    version = "v${version}";
  };

  meta = with lib; {
    changelog = "https://github.com/dependabot/cli/releases/tag/v${version}";
    description = "Tool for testing and debugging Dependabot update jobs";
    mainProgram = "dependabot";
    homepage = "https://github.com/dependabot/cli";
    license = licenses.mit;
    maintainers = with maintainers; [
      infinisil
    ];
  };
}
