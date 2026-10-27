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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "skywalking-eyes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UNR4BV2rhUBgmPOtD4F+YZMTYX7rr4Sb5ag1Rcp4nwE=";
  };

  vendorHash = "sha256-deO/IEu+wayL6MyCxzJ5jAnaF3IeKdgd5hBCD3+YxR0=";

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
