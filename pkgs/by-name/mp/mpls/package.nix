{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "mpls";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "mhersson";
    repo = "mpls";
    tag = "v${version}";
    hash = "sha256-O//9AeJ9x8WF+0ub6KK91efPr9Hdbx1Ab4X0oaUhwss=";
  };

  vendorHash = "sha256-QtNQnJtYLmSTTLwKKQ8P6O6wyctgwN8OcGZkMXa+Ark=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mhersson/mpls/cmd.Version=${version}"
    "-X github.com/mhersson/mpls/internal/mpls.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live preview of markdown using Language Server Protocol";
    homepage = "https://github.com/mhersson/mpls";
    changelog = "https://github.com/mhersson/mpls/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jervw ];
    mainProgram = "mpls";
  };
}
