{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  ipatool,
  writableTmpDirAsHomeHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "ipatool";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "majd";
    repo = "ipatool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yC6MSyL3b9u/mb+YJUIZTsH2dtVgE0w2K3F2LlQE9tI=";
  };

  vendorHash = "sha256-/DIJ41YXPMKZgnNraBasnJ1AIgfC5OA3fLn/vFJqs/Q=";

  # Fixes "import lookup disabled by -mod=vendor" for onepassword-sdk-go on macOS
  proxyVendor = true;

  # Fixes "unable to open output file '/homeless-shelter/.cache/clang/ModuleCache/" on macOS
  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/majd/ipatool/v2/cmd.version=${finalAttrs.version}"
  ];

  # go generate ./... fails because of a missing module: github.com/golang/mock/mockgen
  # which is required to run the tests, check if next release fixes it.
  # preCheck = ''
  #   go generate ./...
  # '';
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd ipatool \
      --bash <($out/bin/ipatool completion bash) \
      --fish <($out/bin/ipatool completion fish) \
      --zsh <($out/bin/ipatool completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = ipatool;
      command = "ipatool --version";
    };
  };

  meta = {
    description = "Command-line tool that allows searching and downloading app packages (known as ipa files) from the iOS App Store";
    homepage = "https://github.com/majd/ipatool";
    changelog = "https://github.com/majd/ipatool/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ipatool";
  };
})
