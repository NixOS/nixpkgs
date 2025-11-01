{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kompose,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "kompose";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wS9YoYEsCALIJMxoVTS6EH6NiBfF+qkFIv7JALnVPgs=";
  };

  vendorHash = "sha256-dBVrkTpeYtTVdA/BEcBGyBdSk3po7TQQwo0ux6qPK2Q=";

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [ "-short" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    package = kompose;
    command = "kompose version";
  };

  meta = with lib; {
    description = "Tool to help users who are familiar with docker-compose move to Kubernetes";
    mainProgram = "kompose";
    homepage = "https://kompose.io";
    changelog = "https://github.com/kubernetes/kompose/releases/tag/${finalAttrs.src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      thpham
      vdemeester
    ];
  };
})
