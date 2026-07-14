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
  version = "0.9.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flyteorg";
    repo = "flyte";
    tag = "flytectl/v${finalAttrs.version}";
    hash = "sha256-p6fU+BLvhwK+4zDNBy4jwtvIll+s4jXmpYIF1mfeoB4=";
  };

  vendorHash = "sha256-h4L8BFzRiph4SBffVRH9TU5j7k+CZGshOV160mENAL0=";

  sourceRoot = "${finalAttrs.src.name}/flytectl";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/flyteorg/flyte/flytestdlib/version.Version=v${finalAttrs.version}"
    "-X github.com/flyteorg/flyte/flytestdlib/version.Build=${finalAttrs.src.tag}"
    "-X github.com/flyteorg/flyte/flytestdlib/version.BuildTime=1970-01-01"
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
