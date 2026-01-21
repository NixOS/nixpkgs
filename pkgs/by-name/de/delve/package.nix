{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "delve";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tFd8g866nRSNUVNz+6SM6YLl4ys3AUP3c8eT1kWbjKY=";
  };

  patches = [
    ./disable-fortify.diff
  ];

  vendorHash = null;

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
