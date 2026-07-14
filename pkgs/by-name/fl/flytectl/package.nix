{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "flytectl";
  version = "1.16.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flyteorg";
    repo = "flyte";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C1VrRdjX33NRqBEAYnmxav9UNECyyQDd+XKtJwYoWFI=";
  };

  vendorHash = "sha256-FJPvi+mfCUQFUu7Ikr2FmvuxEyi7GEer8ceOF9UulBE=";

  sourceRoot = "${finalAttrs.src.name}/flytectl";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/flyteorg/flyte/flytestdlib/version.Version=v${finalAttrs.version}"
    "-X github.com/flyteorg/flyte/flytestdlib/version.Build=${finalAttrs.src.rev}"
    "-X github.com/flyteorg/flyte/flytestdlib/version.BuildTime=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd flytectl \
      --bash <($out/bin/flytectl completion bash) \
      --fish <($out/bin/flytectl completion fish) \
      --zsh <($out/bin/flytectl completion zsh)
  '';

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Command-line interface for Flyte, a cloud-native workflow orchestration platform";
    downloadPage = "https://github.com/flyteorg/flyte";
    homepage = "https://flyte.org/";
    changelog = "https://github.com/flyteorg/flyte/releases/tag/flytectl%2Fv${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.mcuste
      lib.maintainers.ethancedwards8
    ];
    mainProgram = "flytectl";
    platforms = lib.platforms.unix;
  };
})
