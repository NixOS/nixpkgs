{
  lib,
  buildGoModule,
  fetchFromGitHub,
  protobuf,
  git,
  testers,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "buf";
  version = "1.57.2";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "buf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3OzMUROqrQnO1ofwL5hcbx9NgS3WCXwsonp0jKQ/Qlw=";
  };

  vendorHash = "sha256-tX+OBzIIuqCgz7ioDD5OnKpkT6mCdN8/owaOu9kP/kU=";

  patches = [
    # Skip a test that requires networking to be available to work.
    ./skip_broken_tests.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [
    git # Required for TestGitCloner
    protobuf # Required for buftesting.GetProtocFilePaths
  ];

  checkFlags = [
    "-skip=TestWorkspaceGit"
  ];

  preCheck = ''
    # Some tests take longer depending on builder load.
    substituteInPlace private/bufpkg/bufcheck/lint_test.go \
      --replace-fail 'context.WithTimeout(context.Background(), 60*time.Second)' \
                     'context.WithTimeout(context.Background(), 600*time.Second)'
    # For WebAssembly runtime tests
    GOOS=wasip1 GOARCH=wasm go build -o $GOPATH/bin/buf-plugin-suffix.wasm \
      ./private/bufpkg/bufcheck/internal/cmd/buf-plugin-suffix

    # The tests need access to some of the built utilities
    export PATH="$PATH:$GOPATH/bin"
  '';

  # Allow tests that bind or connect to localhost on macOS.
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    # Binaries
    # Only install required binaries, don't install testing binaries
    for FILE in buf protoc-gen-buf-breaking protoc-gen-buf-lint; do
      install -D -m 555 -t $out/bin $GOPATH/bin/$FILE
    done

    # Completions
    installShellCompletion --cmd buf \
      --bash <($GOPATH/bin/buf completion bash) \
      --fish <($GOPATH/bin/buf completion fish) \
      --zsh <($GOPATH/bin/buf completion zsh)

    # Man Pages
    mkdir man && $GOPATH/bin/buf manpages man
    installManPage man/*

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://buf.build";
    changelog = "https://github.com/bufbuild/buf/releases/tag/v${finalAttrs.version}";
    description = "Create consistent Protobuf APIs that preserve compatibility and comply with design best-practices";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
      lrewega
    ];
    mainProgram = "buf";
  };
})
