{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  flyctl,
  installShellFiles,
  git,
}:

buildGoModule rec {
  pname = "flyctl";
  version = "0.3.209";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    leaveDotGit = true;
    hash = "sha256-hzKKCwGTaz1MFQ1+F9piNBnaEDZJwJqoerR1c/uzSsQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-ezGA1LGwQVFMzV/Ogj26pooD06O7FNTXMrYWkv6AwWM=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z"
    "-X github.com/superfly/flyctl/internal/buildinfo.buildVersion=${version}"
  ];
  tags = [ "production" ];

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  patches = [ ./disable-auto-update.patch ];

  preBuild = ''
    # Embed VCS Infos
    export GOFLAGS="$GOFLAGS -buildvcs=true"

    GOOS= GOARCH= CGO_ENABLED=0 go generate ./...
  '';

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  # We override checkPhase to be able to test ./... while using subPackages
  checkPhase = ''
    runHook preCheck
    # We do not set trimpath for tests, in case they reference test assets
    export GOFLAGS=''${GOFLAGS//-trimpath/}

    buildGoDir test ./...

    runHook postCheck
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd flyctl \
      --bash <($out/bin/flyctl completion bash) \
      --fish <($out/bin/flyctl completion fish) \
      --zsh <($out/bin/flyctl completion zsh)
    ln -s $out/bin/flyctl $out/bin/fly
  '';

  passthru.tests.version = testers.testVersion {
    package = flyctl;
    command = "HOME=$(mktemp -d) flyctl version";
    version = "v${flyctl.version}";
  };

  meta = {
    description = "Command line tools for fly.io services";
    downloadPage = "https://github.com/superfly/flyctl";
    homepage = "https://fly.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adtya
      jsierles
      techknowlogick
      RaghavSood
      SchahinRohani
    ];
    mainProgram = "flyctl";
  };
}
