{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkgsBuildBuild,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mock";
  version = "1.4.14";

  src = fetchFromGitHub {
    owner = "dhuan";
    repo = "mock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BkIDvN1161BzL/DIbp8X2FfkQr6RcXBxq5472PLOXuc=";
  };

  vendorHash = "sha256-9L7wTSBgM8MBMBxEJvwZrfqzWM9KeCOj8TZ+lGRwbNU=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # https://github.com/dhuan/mock/blob/master/scripts/create_assets.sh
  postPatch = ''
    substituteInPlace internal/cmd/version.go \
      --replace-fail '__VERSION__' '${finalAttrs.version}' \
      --replace-fail '__GOOS__' "${pkgsBuildBuild.go.GOOS}" \
      --replace-fail '__GOARCH__' "${pkgsBuildBuild.go.GOARCH}"

    substituteInPlace internal/mock/response.go \
      --replace-fail '__MOCK_VERSION__' '${finalAttrs.version}'

    # substituteInPlace tests/e2e/utils/utils.go \
    #   --replace-fail 'BinaryPath: fmt.Sprintf("%s/bin/mock", pwd())' 'BinaryPath: "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}"'
  '';

  checkFlags = [
    # tries to exec /build/source/tests/e2e/../../bin/mock
    "-skip=^Test_(E2E|Middlewares).+"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to do API mocking with scriptable responses";
    homepage = "https://github.com/dhuan/mock";
    changelog = "https://github.com/dhuan/mock/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "mock";
  };
})
