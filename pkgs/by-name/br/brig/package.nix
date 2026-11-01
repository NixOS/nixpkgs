{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "brig";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "brig-sh";
    repo = "brig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HPkr/fHTi8QHIR09PVTDMAPefdtV6K9kYXVLdtbPupY=";
  };

  vendorHash = "sha256-513twbhAd5XxpvGisWoCGwmIFtK0fypViOOBpMNjNEQ=";

  subPackages = [
    "cmd/brig"
    "cmd/brigd"
    "cmd/brig-broker"
  ];

  env.CGO_ENABLED = 0;

  # The binary reads the tag and commit the Go toolchain embeds from a git
  # checkout. A tarball carries none, so the values are passed here, the way
  # the upstream Makefile does for a worktree. Without them `brig version`
  # prints "dev".
  ldflags = [
    "-s"
    "-w"
    "-X github.com/brig-sh/brig/internal/buildinfo.gitCommit=8059e00a8a8741a94177aa19626886f63eb396e1"
    "-X github.com/brig-sh/brig/internal/buildinfo.gitCommitTime=2026-10-31T12:08:40Z"
    "-X github.com/brig-sh/brig/internal/buildinfo.gitDescribe=v${finalAttrs.version}-0-g8059e00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # The tests are written for a source checkout: one of them expects a test
  # binary built from a tarball to carry no commit. The stamped values above
  # are for the shipped binaries only.
  preCheck = ''
    ldflags="-s -w"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd brig \
      --bash <($out/bin/brig completion bash) \
      --fish <($out/bin/brig completion fish) \
      --zsh <($out/bin/brig completion zsh)
  '';

  # On darwin the secret store tests write to the real login keychain.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run coding agents in a microVM sandbox";
    longDescription = ''
      Brig boots a coding agent in a microVM and hands it a project directory
      and named credentials, nothing else. This package holds the brig CLI,
      the brigd session daemon and the brig-broker credential broker. It does
      not include a runtime: on Linux Brig drives nerdctl with the urunc shim,
      on macOS the hull runtime. `brig doctor` reports what is missing, and
      https://brig.sh/docs/install/ says how to install the runtime.
    '';
    homepage = "https://brig.sh";
    changelog = "https://github.com/brig-sh/brig/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "brig";
    maintainers = with lib.maintainers; [ pmoust ];
    platforms = lib.platforms.unix;
  };
})
