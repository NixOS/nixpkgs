{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "talos";
  version = "26.2.0";
  src = fetchFromGitHub {
    owner = "ory";
    repo = "talos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MgjKOfiwU0b3ha2rXewl5c4lGO2En7AgE2y5KtSIhPk=";
  };
  vendorHash = "sha256-uSJHR/GDdCRh8sgw7GEUYUEnkwc9UAA4Qeyc+Ww4z1Q=";
  __structuredAttrs = true;
  env = {
    CGO_ENABLED = 0;
  };
  # equivalent to `go (build|test) ./...`
  subPackages = [ "..." ];
  ldflags = [
    "-s"
    "-X github.com/ory/talos/internal/version.Version=${finalAttrs.src.tag}"
    "-X github.com/ory/talos/internal/version.Commit=${finalAttrs.src.rev}"
  ];
  nativeBuildInputs = [ installShellFiles ];
  __darwinAllowLocalNetworking = true;
  checkFlags =
    let
      skippedTests = [
        # --- FAIL: TestConfigSchemaKeysMatchConstants (0.00s)
        #     schema_keys_test.go:25:
        #                 Error Trace:    github.com/ory/talos/internal/configschema/schema_keys_test.go:125
        #                                   github.com/ory/talos/internal/configschema/schema_keys_test.go:25
        #                 Error:          Received unexpected error:
        #                                 open github.com/ory/talos/internal/config/keys.go: no such file or directory
        #                 Test:           TestConfigSchemaKeysMatchConstants
        "TestConfigSchemaKeysMatchConstants"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd talos \
      --bash <($out/bin/talos completion bash) \
      --fish <($out/bin/talos completion fish) \
      --zsh <($out/bin/talos completion zsh)
  '';
  meta = {
    description = "Server for issuing, verifying, and managing API keys";
    longDescription = ''
      It follows [cloud architecture best practices](https://www.ory.com/docs/ecosystem/software-architecture-philosophy) and focuses on:

      - Issuing, verifying, and revoking API keys at scale
      - Importing externally-issued API keys for unified verification
      - Deriving short-lived JWT and macaroon tokens from long-lived keys
      - Side-car deployment for fast API key verification
      - Low-latency verification with caching and eventual revocation
      - Predictable operations through structured logging, metrics, and tracing
    '';
    homepage = "https://github.com/ory/talos";
    changelog = "https://github.com/ory/talos/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    sourceProvenance = [
      lib.sourceTypes.fromSource
    ];
    maintainers = with lib.maintainers; [
      debtquity
    ];
    mainProgram = "talos";
  };
})
