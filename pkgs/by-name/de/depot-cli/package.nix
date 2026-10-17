{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "depot-cli";
  version = "2.101.73";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "depot";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7nUA8NW+hy79x3u+WTISkNLCeIlrYux5ZBmwlPpq+/w=";
  };

  vendorHash = "sha256-/EcczS/e8vQiCOXaA2J2yY5xM9ymIt1LEObDnC0O1Rc=";

  ldflags = [
    "-s"
    # https://github.com/depot/cli/blob/0b6ec9863dd8cbaab85f6be0b29b59057c4f8008/.github/workflows/ci.yml#L164
    "-X github.com/depot/cli/internal/build.Version=${finalAttrs.version}"
    "-X github.com/depot/cli/internal/build.Date=1970-01-01T00:00:00Z"
    "-X github.com/depot/cli/internal/build.SentryEnvironment=release"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd depot \
      --bash <($out/bin/depot completion bash) \
      --fish <($out/bin/depot completion fish) \
      --zsh <($out/bin/depot completion zsh)
  '';

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Official CLI for the Depot Docker image builder";
    homepage = "https://github.com/depot/cli";
    changelog = "https://github.com/depot/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
    mainProgram = "depot";
  };
})
