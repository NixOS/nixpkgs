{
  lib,
  # broken with go 1.24 for some reason
  buildGo123Module,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
}:

buildGo123Module rec {
  pname = "ko";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "ko-build";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-OQtYyokARrjaf0MWQ0sMqJPb+C5pRkKFumAmtxS4SBo=";
  };

  vendorHash = "sha256-YQggwX6fUsfZMM+GdgeNAIHkfX84FMF84xHsP/SNiS4=";

  nativeBuildInputs = [ installShellFiles ];

  # Pin so that we don't build the several other development tools
  subPackages = ".";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/ko/pkg/commands.Version=${version}"
  ];

  checkFlags = [
    # requires docker daemon, pulls and builds delve debugger
    "-skip=(TestNewPublisherCanPublish|TestDebugger)"
  ];

  nativeCheckInputs = [ gitMinimal ];
  preCheck = ''
    # Feed in all the tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    getGoDirs() {
      go list ./...
    }

    # resolves some complaints from ko
    export GOROOT="$(go env GOROOT)"
    git init

    # ko tests will fail if any of those env are set, as ko tries
    # to make sure it can build and target multiple GOOS/GOARCH
    unset GOOS GOARCH GOARM
  '';

  postInstall = ''
    installShellCompletion --cmd ko \
      --bash <($out/bin/ko completion bash) \
      --fish <($out/bin/ko completion fish) \
      --zsh <($out/bin/ko completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/ko-build/ko";
    changelog = "https://github.com/ko-build/ko/releases/tag/v${version}";
    description = "Build and deploy Go applications";
    mainProgram = "ko";
    longDescription = ''
      ko is a simple, fast container image builder for Go applications.
      It's ideal for use cases where your image contains a single Go application without any/many dependencies on the OS base image (e.g. no cgo, no OS package dependencies).
      ko builds images by effectively executing go build on your local machine, and as such doesn't require docker to be installed. This can make it a good fit for lightweight CI/CD use cases.
      ko makes multi-platform builds easy, produces SBOMs by default, and includes support for simple YAML templating which makes it a powerful tool for Kubernetes applications.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [
      nickcao
      jk
      vdemeester
      developer-guy
    ];
  };
}
