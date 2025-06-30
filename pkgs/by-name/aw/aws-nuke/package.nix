{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "3.55.0";

  src = fetchFromGitHub {
    owner = "ekristen";
    repo = "aws-nuke";
    tag = "v${version}";
    hash = "sha256-wqUKI8FvQrSs0Lz6YXdieh6I5QccQEtXUMEOtB8angs=";
  };

  vendorHash = "sha256-QbZuOnlN9GC1cMMoOrUcFxkJx8y4Iz+JpeBtkpv1s4s=";

  overrideModAttrs = _: {
    preBuild = ''
      go generate ./...
    '';
  };

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ekristen/aws-nuke/v${lib.versions.major version}/pkg/common.SUMMARY=${version}"
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

  versionCheckProgramArg = "--version";

  postInstallCheck = ''
    $out/bin/aws-nuke resource-types | grep "IAMUser"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remove all the resources from an AWS account";
    homepage = "https://github.com/ekristen/aws-nuke";
    changelog = "https://github.com/ekristen/aws-nuke/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grahamc ];
    mainProgram = "aws-nuke";
    # fork/exec exe/mockgen: exec format error
    # resources/autoscaling_mock_test.go:1: running "../mocks/generate_mocks.sh": exit status 1
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
