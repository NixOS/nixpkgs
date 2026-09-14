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
  version = "1.92.0";

  # `tag` is what `dependabot` uses to find the relevant docker images.
  tag = "nixpkgs-dependabot-cli-${version}";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy --image-tag latest --final-image-name dependabot-update-job-proxy --final-image-tag ${tag}
  updateJobProxy.imageDigest = "sha256:70cf9a8f006db9cde732faf9e33a4f60af895532bbe803268fc8fd2f70aa3202";
  updateJobProxy.hash = "sha256-pUkYBdX/HfrY/4sigvAjeuNSB1qW5He5DK1YLpigkIw=";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/dependabot/dependabot-updater-github-actions --image-tag latest --final-image-name dependabot-updater-github-actions --final-image-tag ${tag}
  updaterGitHubActions.imageDigest = "sha256:19b4c86484ebdfbb949c8270256d74a18f6531b15a92182150739569fc5b7497";
  updaterGitHubActions.hash = "sha256-xSJNvM1NYzlgCkUMUyisfGSsTW3oijOncIm8tgQxBZ4=";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-YDPMvxhHVu3XVM3VuDfcXSnUHPf/SbCu95N6nYNqsIQ=";
  };

  vendorHash = "sha256-AQiW01KTraI29Cl6BhL0jmADqAZz/ORFeIu5SDyXD44=";

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

  # Some tests fail on *-darwin because they require host port binding or a Docker environment.
  # So, we skip the test entirely on *-darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;

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
