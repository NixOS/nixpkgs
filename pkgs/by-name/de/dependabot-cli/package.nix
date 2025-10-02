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
  version = "1.72.0";

  # `tag` is what `dependabot` uses to find the relevant docker images.
  tag = "nixpkgs-dependabot-cli-${version}";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy --image-tag latest --final-image-name dependabot-update-job-proxy --final-image-tag ${tag}
  updateJobProxy.imageDigest = "sha256:b0a4c841300510255d6e647e9bcdb939d194bc644dee7962a543f637515b0f23";
  updateJobProxy.hash = "sha256-+drR2uTtaQU0ckPTEbEBj5yvDtSP0BC3D0MxqRZ1Cjc=";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/dependabot/dependabot-updater-github-actions --image-tag latest --final-image-name dependabot-updater-github-actions --final-image-tag ${tag}
  updaterGitHubActions.imageDigest = "sha256:3cbd297b1181de69e72a43ce2d7aa02eb7c2e71bc0c11d41288a86384af24aa0";
  updaterGitHubActions.hash = "sha256-Btn7bsBNJb34T7JXmgpTxkxBXXT9IpQihernhNAT/HQ=";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-YI5HkypIEWkPmdtPvMrOp7r71ccucAEKNFo/va6yICE=";
  };

  vendorHash = "sha256-KrjwObQ3o5A0JuOW71EKNi9yNJYwsPHI+6a0AZY/cqU=";

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
