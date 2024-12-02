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
  version = "1.57.0";

  # vv Also update this vv
  tag = "nixpkgs-dependabot-cli-${version}";
  updateJobProxy = dockerTools.pullImage {
    imageName = "ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy";
    # Get these hashes from
    # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/github/dependabot-update-job-proxy/dependabot-update-job-proxy --image-tag latest --final-image-name dependabot-update-job-proxy --final-image-tag ${tag}
    imageDigest = "sha256:cc4a9b7db8ddf3924b6c25cc8a74d9937bf803e64733035809862a1c0a6df984";
    sha256 = "0wkr0rac7dp1080s4zik5yzi5967gkfylly2148ipgw50sp0sq8s";

    # Don't update this, it's used to refer to the imported image later
    finalImageName = "dependabot-update-job-proxy";
    finalImageTag = tag;
  };
  updaterGitHubActions = dockerTools.pullImage {
    imageName = "ghcr.io/dependabot/dependabot-updater-github-actions";
    # Get these hashes from
    # nix run nixpkgs#nix-prefetch-docker -- --image-name ghcr.io/dependabot/dependabot-updater-github-actions --image-tag latest --final-image-name dependabot-updater-github-actions --final-image-tag ${tag}
    imageDigest = "sha256:6665b3e26ef97577e83f2dfd0007a73c02b003126e72c0b4b196fe570088ed93";
    sha256 = "0q7w3yp49wb70gkjjl2syvs75hm1jkva2qslzckwxh73z0kq2z0q";

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
    hash = "sha256-ZT1fwDT19uUjp5iG0NLSrc/6PLW/sukAd0w66mLdFVg=";
  };

  vendorHash = "sha256-jSINiETadd0ixzFBilgphi1vJNsRYeDkbaVNk5stTp4=";

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
      l0b0
      infinisil
    ];
  };
}
