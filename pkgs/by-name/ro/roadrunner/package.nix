{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "roadrunner";
  version = "2025.1.14";

  src = fetchFromGitHub {
    owner = "roadrunner-server";
    repo = "roadrunner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Mfu/De28tWCygJ5/QJnOzxk88aajx4Oq/Xm0TOXR0M=";
  };

  vendorHash = "sha256-KuATz7rVsDuGiyILvILaEpznI63sCHx0G+9D2vR+dx0=";
  env.GOWORK = "off";

  subPackages = [ "cmd/rr" ];

  # Flags as provided by the build automation of the project:
  # https://github.com/roadrunner-server/roadrunner/blob/3853ad693522e82d53d62950e5f1315402c910f2/.github/workflows/release.yml#L82
  ldflags = [
    "-s"
    "-X=github.com/roadrunner-server/roadrunner/v${lib.versions.major finalAttrs.version}/internal/meta.version=${finalAttrs.version}"
    "-X=github.com/roadrunner-server/roadrunner/v${lib.versions.major finalAttrs.version}/internal/meta.buildTime=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rr \
      --bash <($out/bin/rr completion bash) \
      --zsh <($out/bin/rr completion zsh) \
      --fish <($out/bin/rr completion fish)
  '';

  postPatch = ''
    substituteInPlace internal/rpc/client_test.go \
      --replace "127.0.0.1:55555" "127.0.0.1:55554"

    substituteInPlace internal/rpc/test/config_rpc_ok.yaml \
      --replace "127.0.0.1:55555" "127.0.0.1:55554"

    substituteInPlace internal/rpc/test/config_rpc_conn_err.yaml \
      --replace "127.0.0.1:0" "127.0.0.1:55554"
  '';

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/roadrunner-server/roadrunner/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "High-performance PHP application server, process manager written in Go and powered with plugins";
    homepage = "https://roadrunner.dev";
    license = lib.licenses.mit;
    mainProgram = "rr";
    maintainers = [ ];
  };
})
