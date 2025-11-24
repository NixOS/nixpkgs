{
  lib,
  stdenv,
  buildGoModule,
  dependabot-cli,
  dockerTools,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  symlinkJoin,
  testers,
}:
let
  pname = "dependabot-cli";
  version = "1.78.1";

  # `tag` is what `dependabot` uses to find the relevant docker images.
  tag = "nixpkgs-dependabot-cli-${version}";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy --image-tag latest --final-image-name dependabot-update-job-proxy --final-image-tag ${tag}
  updateJobProxy.imageDigest = "sha256:53f33581efa03f1ed691b44896b231923888ba24b0e12cdc440aac2333d532c5";
  updateJobProxy.hash = "sha256-M7vf5YS4ORG0TY+iHXL6nNAJhwgtO4PZbO4EEBBT6qo=";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/dependabot/dependabot-updater-github-actions --image-tag latest --final-image-name dependabot-updater-github-actions --final-image-tag ${tag}
  updaterGitHubActions.imageDigest = "sha256:a719a18ffb9aa87dba253be94e137ba7561fdf59f60d9a67c3ebc840ab2058a7";
  updaterGitHubActions.hash = "sha256-nb8uX3pu+m7cu6Owi9EnWmUT4Epr4yXScSIFBR/Kb6Q=";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Q6WZ7FrcEGfUfG/3Zx8Z4Jd+CB6pEcw1fDo3AF8ML4M=";
  };

  vendorHash = "sha256-dD48OKpuGAJAro7qV4tqpf/uENV2X1VQ2kUvAuJLXc0=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=v${version}"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    postBuild =
      let
        updateJobProxyImage = dockerTools.pullImage {
          imageName = "ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy";
          finalImageName = "dependabot-update-job-proxy";
          finalImageTag = tag;
          inherit (updateJobProxy) imageDigest hash;
        };

        updaterGitHubActionsImage = dockerTools.pullImage {
          imageName = "ghcr.io/dependabot/dependabot-updater-github-actions";
          finalImageName = "dependabot-updater-github-actions";
          finalImageTag = tag;
          inherit (updaterGitHubActions) imageDigest hash;
        };
      in
      ''
        # Create a wrapper that pins the docker images that `dependabot` uses.
        wrapProgram $out/bin/dependabot \
          --run "docker load --input ${updateJobProxyImage} >&2" \
          --add-flags "--proxy-image=dependabot-update-job-proxy:${tag}" \
          --run "docker load --input ${updaterGitHubActionsImage} >&2" \
          --add-flags "--updater-image=dependabot-updater-github-actions:${tag}"
      '';
  };

  passthru.tests.version = testers.testVersion {
    package = dependabot-cli;
    command = "dependabot --version";
    version = "v${version}";
  };

  meta = {
    changelog = "https://github.com/dependabot/cli/releases/tag/v${version}";
    description = "Tool for testing and debugging Dependabot update jobs";
    mainProgram = "dependabot";
    homepage = "https://github.com/dependabot/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      infinisil
      philiptaron
    ];
  };
}
