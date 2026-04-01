{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "skywalking-eyes";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "skywalking-eyes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uk/tX1AfYfy4ARzyd9IZijFYBEsfrx/DX+QsTVg3Jc4=";
  };

  vendorHash = "sha256-sH9zV99XX7f8q7guBDkLAJ7Lr3eiQXSQ2+CGd2zphLk=";

  subPackages = [ "cmd/license-eye" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/apache/skywalking-eyes/commands.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd license-eye \
      --bash <($out/bin/license-eye completion bash) \
      --zsh <($out/bin/license-eye completion zsh) \
      --fish <($out/bin/license-eye completion fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Check and fix license headers and resolve dependencies' licenses";
    homepage = "https://github.com/apache/skywalking-eyes";
    changelog = "https://github.com/apache/skywalking-eyes/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ janezp ];
    mainProgram = "license-eye";
  };
})
