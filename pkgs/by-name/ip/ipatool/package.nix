{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ipatool";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "majd";
    repo = "ipatool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oWcP+CSMq6lnm/Qz1h+1A8Ivp1IpR5MFe42EUjz1eeg=";
  };

  vendorHash = "sha256-Fb5Zufd/K8a0why62V8ShQR65P/FefRFfde5tYVB4JQ=";

  # Fixes "import lookup disabled by -mod=vendor" for onepassword-sdk-go on macOS
  proxyVendor = true;

  # Upstream added a developer tool, profilegen, that should not be installed
  subPackages = [ "." ];

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool that allows searching and downloading app packages (known as ipa files) from the iOS App Store";
    homepage = "https://github.com/majd/ipatool";
    changelog = "https://github.com/majd/ipatool/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ipatool";
  };
})
