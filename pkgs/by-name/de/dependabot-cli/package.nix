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
  version = "1.76.0";

  # `tag` is what `dependabot` uses to find the relevant docker images.
  tag = "nixpkgs-dependabot-cli-${version}";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy --image-tag latest --final-image-name dependabot-update-job-proxy --final-image-tag ${tag}
  updateJobProxy.imageDigest = "sha256:42b2a171891f4667d9a443cbfdc5f10a58e5b5d7f1b9eae6c12ec9815bec72fd";
  updateJobProxy.hash = "sha256-+GcGyip8cgVBZeji6Zn3oN8Mc3xZvASohbPVNUbHOgA=";

  # Get these hashes from
  # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/dependabot/dependabot-updater-github-actions --image-tag latest --final-image-name dependabot-updater-github-actions --final-image-tag ${tag}
  updaterGitHubActions.imageDigest = "sha256:d26d4ce071684b63d935c550552ae0d129f845254cb1e2f8635f15c62f43319e";
  updaterGitHubActions.hash = "sha256-21E8q1+cwYlD8FL5njGhpsGRd/YkGQNS/y0howQFp6g=";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-fSb2zzddwGJ1r9NhPEhE1WCndyoBK4VLOP3CmQUcjy0=";
  };

  vendorHash = "sha256-xdouoPEPPhHcXNWxMdcdxVQsgRlFXBXjyZQ7CcROA4U=";

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
