{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  func,
}:

buildGoModule (finalAttrs: {
  pname = "func";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "func";
    tag = "knative-v${finalAttrs.version}";
    hash = "sha256-nbS7X5WPu+WBtPUKShE5aWve5m2gw2naQQzNeG7pbGM=";
  };

  vendorHash = "sha256-Gn+nyck/VOwf8iKPeyLvsPWOpfdN/maUcQOLFAU0oic=";

  subPackages = [ "cmd/func" ];

  ldflags = [
    "-X knative.dev/func/pkg/app.vers=v${finalAttrs.version}"
    "-X main.date=19700101T000000Z"
    "-X knative.dev/func/pkg/app.hash=${finalAttrs.version}"
    "-X knative.dev/func/pkg/app.kver=${finalAttrs.src.tag}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd func \
      --bash <($out/bin/func completion bash) \
      --zsh <($out/bin/func completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = func;
    command = "func version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Knative client library and CLI for creating, building, and deploying Knative Functions";
    mainProgram = "func";
    homepage = "https://github.com/knative/func";
    changelog = "https://github.com/knative/func/releases/tag/knative-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ maxwell-lt ];
  };
})
