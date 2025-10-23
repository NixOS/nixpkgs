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
  version = "0.63.0";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gmfzMup4fdsbdyUufxjcJRPF2faj3RUlvIn2ciyalaQ=";
  };
  vendorHash = "sha256-pBUWM6st5FhhOki3n9NIN4/U8JB7Kq3Aph3AtQs+Ogg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/conftest/internal/commands.version=${finalAttrs.version}"
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
  versionCheckProgramArg = "--version";

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
