{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  asciidoctor,
  installShellFiles,
  git,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "git-lfs";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    tag = "v${version}";
    hash = "sha256-EFuuyD83aYe6XMKbRfAykVMfGFOQ4I6ORvMRm0Q8vfM=";
  };

  vendorHash = "sha256-6H0KpLin+DqwEg5bdzaxj2CoNSneZ/ET43MTrrdF3h8=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/git-lfs/git-lfs/v${lib.versions.major version}/config.Vendor=${version}"
  ];

  subPackages = [ "." ];

  preBuild = ''
    GOARCH= go generate ./commands
  '';

  postBuild = ''
    make man
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    unset subPackages
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin (
    let
      # Fail in the sandbox with network-related errors.
      # Enabling __darwinAllowLocalNetworking is not enough.
      skippedTests = [
        "TestAPIBatch"
        "TestAPIBatchOnlyBasic"
        "TestAuthErrWithBody"
        "TestAuthErrWithoutBody"
        "TestCertFromSSLCAInfoConfig"
        "TestCertFromSSLCAInfoEnv"
        "TestCertFromSSLCAInfoEnvWithSchannelBackend"
        "TestCertFromSSLCAPathConfig"
        "TestCertFromSSLCAPathEnv"
        "TestClientRedirect"
        "TestClientRedirectReauthenticate"
        "TestDoAPIRequestWithAuth"
        "TestDoWithAuthApprove"
        "TestDoWithAuthNoRetry"
        "TestDoWithAuthReject"
        "TestFatalWithBody"
        "TestFatalWithoutBody"
        "TestHttp2"
        "TestHttpVersion"
        "TestWithNonFatal500WithBody"
        "TestWithNonFatal500WithoutBody"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ]
  );

  postInstall = ''
    installManPage man/man*/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-lfs \
      --bash <($out/bin/git-lfs completion bash) \
      --fish <($out/bin/git-lfs completion fish) \
      --zsh <($out/bin/git-lfs completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Git extension for versioning large files";
    homepage = "https://git-lfs.github.com/";
    changelog = "https://github.com/git-lfs/git-lfs/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
    mainProgram = "git-lfs";
  };
}
