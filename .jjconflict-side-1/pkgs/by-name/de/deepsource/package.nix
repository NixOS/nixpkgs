{
  lib,
  stdenv,
  installShellFiles,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "deepsource";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "DeepSourceCorp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-6uNb4cQVerrlW/eUkjmlO1i1YKYX3qaVdo0i5cczt+I=";
  };

  nativeBuildInputs = [ installShellFiles ];

  doCheck = true;

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestReportKeyValueWorkflow"
        "TestReportAnalyzerTypeWorkflow"
        "TestReportKeyValueFileWorkflow"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = "sha256-SsMq4ngq3sSOL28ysHTxTF4CT9sIcCIW7yIhBxIPrNs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd deepsource \
      --bash <($out/bin/deepsource completion bash) \
      --fish <($out/bin/deepsource completion fish) \
      --zsh <($out/bin/deepsource completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Command line interface to DeepSource, the code health platform";
    mainProgram = "deepsource";
    homepage = "https://github.com/DeepSourceCorp/cli";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nipeharefa ];
  };
}
