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
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "func";
    tag = "knative-v${finalAttrs.version}";
    hash = "sha256-SYqkWE7dVFy6stibcWayU2J+oIFIfwNDoK6TzchgBzo=";
  };

  vendorHash = "sha256-F/TQ1QwfQfum1DOY2xrzpTlm7jvuJQUjtBLY6pZfTh8=";

  subPackages = [ "cmd/func" ];

  ldflags = [
    "-X knative.dev/func/pkg/version.Vers=v${finalAttrs.version}"
    "-X main.date=19700101T000000Z"
    "-X knative.dev/func/pkg/version.Hash=${finalAttrs.version}"
    "-X knative.dev/func/pkg/version.Kver=${finalAttrs.src.tag}"
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
