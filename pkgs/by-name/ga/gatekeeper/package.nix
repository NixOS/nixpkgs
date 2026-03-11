{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gatekeeper";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "gatekeeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ARgrazsIx3w9BLqI9kWV794ojvZgIdNMGsjAXs19u1g=";
  };

  vendorHash = "sha256-2mnUYuxQ6wXOpK/V+8KpF0f5bkYRBgqJEl1bKOLTHNE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/gator" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gator \
      --bash <($out/bin/gator completion bash) \
      --fish <($out/bin/gator completion fish) \
      --zsh <($out/bin/gator completion zsh)
  '';

  meta = {
    description = "Policy Controller for Kubernetes";
    mainProgram = "gator";
    homepage = "https://github.com/open-policy-agent/gatekeeper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
