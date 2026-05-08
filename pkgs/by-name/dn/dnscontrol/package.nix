{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dnscontrol";
  version = "4.37.1";

  src = fetchFromGitHub {
    owner = "DNSControl";
    repo = "dnscontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qpvT1jhFNNmHsiJe3RsbxmgXd4OOX7+uqxjCBKERwkw=";
  };

  vendorHash = "sha256-M+Wx3I2KCKI3fHHw6t5WhCcJkHvxswC3G0Zt8SAQ0ZI=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X=github.com/DNSControl/dnscontrol/v${lib.versions.major finalAttrs.version}/pkg/version.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dnscontrol \
      --bash <($out/bin/dnscontrol shell-completion bash) \
      --zsh <($out/bin/dnscontrol shell-completion zsh)
  '';

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://dnscontrol.org/";
    changelog = "https://github.com/DNSControl/dnscontrol/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      zowoq
    ];
    mainProgram = "dnscontrol";
  };
})
