{
  buildGoModule,
  stdenv,
  lib,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "deck";
  version = "1.70.0";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "deck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a65sr6UYW3hPHThj/1/xokPN9K02A7N6fUckKTh/h2o=";
  };

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X github.com/kong/deck/cmd.VERSION=${finalAttrs.version}"
    "-X github.com/kong/deck/cmd.COMMIT=${finalAttrs.src.rev}"
  ];

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-jZdacu1WwLh+hWsysCbwHl8AeHCAxkUvPG1v5KsncNs=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd deck \
      --bash <($out/bin/deck completion bash) \
      --fish <($out/bin/deck completion fish) \
      --zsh <($out/bin/deck completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configuration management and drift detection tool for Kong";
    homepage = "https://github.com/Kong/deck";
    license = lib.licenses.asl20;
    mainProgram = "deck";
    maintainers = with lib.maintainers; [ liyangau ];
  };
})
