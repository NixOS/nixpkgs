{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pv-migrate";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "pv-migrate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-FJalS3cUaYFs1ChAH1JA6qrRYorDQaLvWzKIE21jYPs=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-KFcz6SAUIg8hi+Vo/Wf6jDF6QcZ5uNueee3sG9t2zyU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pv-migrate \
      --bash <($out/bin/pv-migrate completion bash) \
      --fish <($out/bin/pv-migrate completion fish) \
      --zsh <($out/bin/pv-migrate completion zsh)
  '';

  meta = {
    mainProgram = "pv-migrate";
    description = "CLI tool to easily migrate Kubernetes persistent volumes";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.afl20;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      qjoly
    ];
  };
})
