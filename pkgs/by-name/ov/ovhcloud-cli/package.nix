{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "ovhcloud-cli";
  version = "0.17.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "ovhcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fIO5Wtyt6jG4ttD/EUHEbutWGzvPRku5YlExNhhHxW4=";
  };

  vendorHash = "sha256-a3RnOhYC2oKV6y3sidHf1KfGAyk1l4Q5grhXzY+JSFc=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ovh/ovhcloud-cli/internal/version.Version=${finalAttrs.version}"
  ];

  excludedPackages = [ "cmd/docgen" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ovhcloud \
      --bash <($out/bin/ovhcloud completion bash) \
      --fish <($out/bin/ovhcloud completion fish) \
      --zsh <($out/bin/ovhcloud completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/ovh/ovhcloud-cli";
    changelog = "https://github.com/ovh/ovhcloud-cli/releases/tag/${finalAttrs.src.tag}";
    description = "Command Line Interface to manage your OVHcloud services";
    mainProgram = "ovhcloud";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
})
