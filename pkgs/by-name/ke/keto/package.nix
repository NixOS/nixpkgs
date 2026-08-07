{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "keto";
  version = "26.2.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "keto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wRtz4RvJ7LxVnSLmXVZFGa9QXjcPnDNJxHKosbyTed0=";
  };

  vendorHash = "sha256-B27aC4yXS36eOoq53+RWp0vq1Oqw2aR+gOjv0m+b/I4=";

  __structuredAttrs = true;

  tags = [
    "sqlite"
    "json1"
    "hsm"
  ];

  subPackages = [ "..." ];

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-X github.com/ory/keto/internal/driver/config.Version=${finalAttrs.src.tag}"
    "-X github.com/ory/keto/internal/driver/config.Commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  # tests use dynamic port assignment via port `0`
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export version='${finalAttrs.src.tag}'
  '';
  checkFlags = [
    "-short"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd keto \
      --bash <($out/bin/keto completion bash) \
      --fish <($out/bin/keto completion fish) \
      --zsh <($out/bin/keto completion zsh)
  '';

  meta = {
    description = "Scalable and customizable permission server ";
    longDescription = ''
      Open source implementation of "Zanzibar: Google's Consistent, Global Authorization System". It follows
      [cloud architecture best practices](https://www.ory.com/docs/ecosystem/software-architecture-philosophy)
      and focuses on:

      - Scalable permission checks based on the Zanzibar model
      - The Ory Permission Language for defining access control policies
      - Relationship-based access control (ReBAC)
      - Low latency permission checks (sub-10ms)
      - Horizontal scaling to billions of relationships
      - Consistency and high availability
    '';
    homepage = "https://github.com/ory/keto";
    changelog = "https://github.com/ory/keto/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mrmebelman
      debtquity
    ];
    mainProgram = "keto";
  };
})
