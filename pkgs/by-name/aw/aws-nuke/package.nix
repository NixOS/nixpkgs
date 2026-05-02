{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "aws-nuke";
  version = "3.64.1";

  src = fetchFromGitHub {
    owner = "ekristen";
    repo = "aws-nuke";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oDQcwj3CXud7iOC9UbfQQMcTv0Jp0bCMD8TgMSoG+xw=";
  };

  vendorHash = "sha256-NgnaGCyYe21F0T0NeLD0X0i/Q7lgXmiB5tKP0UJiht0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ekristen/aws-nuke/v${lib.versions.major finalAttrs.version}/pkg/common.SUMMARY=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd aws-nuke \
      --bash <($out/bin/aws-nuke completion bash) \
      --fish <($out/bin/aws-nuke completion fish) \
      --zsh <($out/bin/aws-nuke completion zsh)
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstallCheck = ''
    $out/bin/aws-nuke resource-types | grep "IAMUser"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remove all the resources from an AWS account";
    homepage = "https://github.com/ekristen/aws-nuke";
    changelog = "https://github.com/ekristen/aws-nuke/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "aws-nuke";
    # fork/exec exe/mockgen: exec format error
    # resources/autoscaling_mock_test.go:1: running "../mocks/generate_mocks.sh": exit status 1
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})
