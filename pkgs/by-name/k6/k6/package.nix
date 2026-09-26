{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "k6";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "k6";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2F1n/VlHpyLlAzycSCV25+pa35bzSwgWTSE/NU21G+I=";
  };

  subPackages = [ "./" ];

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd k6 \
      --bash <($out/bin/k6 completion bash) \
      --fish <($out/bin/k6 completion fish) \
      --zsh <($out/bin/k6 completion zsh)
  '';

  meta = {
    description = "Modern load testing tool, using Go and JavaScript";
    mainProgram = "k6";
    homepage = "https://k6.io/";
    changelog = "https://github.com/grafana/k6/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
