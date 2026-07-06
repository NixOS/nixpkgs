{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "delve";
  version = "1.26.3";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R7rxWJZ1AfwH/ytgQnq21D5d4YRm3fzYSIG0eugww1U=";
  };

  patches = [
    ./disable-fortify.diff
  ];

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/dlv" ];

  ldflags = [
    "-s"
    "-w"
  ];

  hardeningDisable = [ "fortify" ];

  preCheck = ''
    XDG_CONFIG_HOME=$(mktemp -d)
  '';

  # Disable tests on Darwin as they require various workarounds.
  #
  # - Tests requiring local networking fail with or without sandbox,
  #   even with __darwinAllowLocalNetworking allowed.
  # - CGO_FLAGS warnings break tests' expected stdout/stderr outputs.
  # - DAP test binaries exit prematurely.
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    # add symlink for vscode golang extension
    # https://github.com/golang/vscode-go/blob/master/docs/debugging.md#manually-installing-dlv-dap
    ln $out/bin/dlv $out/bin/dlv-dap

    installShellCompletion --cmd dlv \
      --bash <($out/bin/dlv completion bash) \
      --fish <($out/bin/dlv completion fish) \
      --zsh <($out/bin/dlv completion zsh)
  '';

  # delve doesn't support --version
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Debugger for the Go programming language";
    homepage = "https://github.com/go-delve/delve";
    changelog = "https://github.com/go-delve/delve/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.mit;
    mainProgram = "dlv";
  };
})
