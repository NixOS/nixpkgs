{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "conftest";
  version = "0.69.0";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kF4kako/88FxV10RZ9zNM7eq/Qlz41tEtnUnTB12KtM=";
  };
  vendorHash = "sha256-vcIY3AZkl/U0l2eyWHZGHrjQyW5TWt9oPDb4BXcNUtY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/conftest/internal/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      conftest =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.conftest;
    in
    ''
      installShellCompletion --cmd conftest \
        --bash <(${conftest}/bin/conftest completion bash) \
        --fish <(${conftest}/bin/conftest completion fish) \
        --zsh <(${conftest}/bin/conftest completion zsh)
    '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckKeepEnvironment = [ "XDG_DATA_HOME" ];
  preVersionCheck = ''
    export XDG_DATA_HOME="$(mktemp -d)"
  '';

  meta = {
    description = "Write tests against structured configuration data";
    mainProgram = "conftest";
    downloadPage = "https://github.com/open-policy-agent/conftest";
    homepage = "https://www.conftest.dev";
    changelog = "https://github.com/open-policy-agent/conftest/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    longDescription = ''
      Conftest helps you write tests against structured configuration data.
      Using Conftest you can write tests for your Kubernetes configuration,
      Tekton pipeline definitions, Terraform code, Serverless configs or any
      other config files.

      Conftest uses the Rego language from Open Policy Agent for writing the
      assertions. You can read more about Rego in 'How do I write policies' in
      the Open Policy Agent documentation.
    '';
    maintainers = with lib.maintainers; [
      jk
      yurrriq
    ];
  };
})
