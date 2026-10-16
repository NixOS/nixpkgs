{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "dnscontrol";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "DNSControl";
    repo = "dnscontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kub4DguRCOybMY5YehhPuGXK1q3Zm0nunU00l33fK1U=";
  };

  vendorHash = "sha256-aEhK1Q/A8rrzNR75QEZJ7+03fJxDv19jakVkgDWyBk4=";

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
