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
  version = "3.63.2";

  src = fetchFromGitHub {
    owner = "ekristen";
    repo = "aws-nuke";
    tag = "v${version}";
    hash = "sha256-I/T5zLAPw6SoVbs+gkacd/oo2EEbyAS/GRFnHjWPSks=";
  };

  vendorHash = "sha256-cmfd02x5nmZfHbkWJ0xk7AzwFNokr//p+lHR6sRAyVQ=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ekristen/aws-nuke/v${lib.versions.major version}/pkg/common.SUMMARY=${version}"
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
    changelog = "https://github.com/ekristen/aws-nuke/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "aws-nuke";
    # fork/exec exe/mockgen: exec format error
    # resources/autoscaling_mock_test.go:1: running "../mocks/generate_mocks.sh": exit status 1
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
