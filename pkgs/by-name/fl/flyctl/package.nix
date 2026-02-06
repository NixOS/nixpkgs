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
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    leaveDotGit = true;
    hash = "sha256-wB23vNqd+Fmx2ZnF+aOelakLXxNrubAdJPZRDIoG+YM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-0uInt5zqjN0EbqxBlnLpJBhpky6uQJsohrYaDwJ/Bps=";

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

  # Tests require rake and other tools not in the sandbox
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$(mktemp -d)
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
