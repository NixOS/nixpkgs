{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "score-compose";
  version = "0.36.6";

  src = fetchFromGitHub {
    owner = "score-spec";
    repo = "score-compose";
    tag = finalAttrs.version;
    hash = "sha256-SCmFA1SgebDSzx/bWuxwwdq1zCE8VdSXk+TigPpjAkU=";
  };

  vendorHash = "sha256-OT5jqaVlEMDUyhFliXXdlN36LUll3K3fc1r47977aT8=";

  subPackages = [ "cmd/score-compose" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/score-spec/score-compose/internal/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "CLI to generate Docker Compose manifests from Score specs";
    homepage = "https://github.com/score-spec/score-compose";
    changelog = "https://github.com/score-spec/score-compose/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "score-compose";
    maintainers = with lib.maintainers; [ jocelynthode ];
  };

  passthru.updateScript = nix-update-script { };
})
