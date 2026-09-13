{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "chart-doc-gen";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubepack";
    repo = "chart-doc-gen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iEI0W5806BvIpEwkI7TdApzqqRFQFfjRn7EI1c59N8U=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Helm Chart Documentation Generator";
    homepage = "https://github.com/kubepack/chart-doc-gen";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tembleking ];
    mainProgram = "chart-doc-gen";
  };
})
