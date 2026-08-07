{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "hydra";
  version = "26.2.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LnF1k/C9uPRY4xXeBCJPSQ8gxwwZx0N1e1s+Rhop5ic=";
  };

  vendorHash = "sha256-KVCoDATyt5Qp0r3vGwdXqkjh0FEdNyKi6mXk99D6HD8=";

  __structuredAttrs = true;
  # `json1` not needed (see: https://github.com/ory/hydra/commit/93edc9ad894771c67f46ae2c57ee7e50382d73cd)
  # `sqlite_omit_load_extension` consistency with upstream (see: https://github.com/ory/hydra/blob/master/.docker/Dockerfile-local-build#L20C58-L20C84). Will disable sqlite runtime extension loading (see: https://sqlite.org/loadext.html)
  tags = [
    "hsm"
    "sqlite"
    "sqlite_omit_load_extension"
  ];

  subPackages = [ "..." ];

  ldflags = [
    "-s"
    "-X github.com/ory/hydra/v2/driver/config.Version=${finalAttrs.src.tag}"
    "-X github.com/ory/hydra/v2/driver/config.Commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  # tests use dynamic port assignment via port `0`
  __darwinAllowLocalNetworking = true;
  preCheck = ''
    export version="${finalAttrs.src.tag}"
  '';
  checkFlags = [
    "-short"
  ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hydra \
      --bash <($out/bin/hydra completion bash) \
      --fish <($out/bin/hydra completion fish) \
      --zsh <($out/bin/hydra completion zsh)
  '';

  meta = {
    description = "OpenID Certified™ OAuth 2.0 Server and OpenID Connect Provider";
    longDescription = ''
      Server implementation of the OAuth 2.0 authorization framework and the OpenID Connect Core 1.0. It follows
      [cloud architecture best practices](https://www.ory.com/docs/ecosystem/software-architecture-philosophy) and focuses on:

      - OAuth 2.0 and OpenID Connect flows
      - Token issuance and validation
      - Client management
      - Consent and login flow orchestration
      - JWKS management
      - Low latency and high throughput
    '';
    homepage = "https://github.com/ory/hydra";
    changelog = "https://github.com/ory/hydra/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      debtquity
    ];
    mainProgram = "hydra";
  };
})
