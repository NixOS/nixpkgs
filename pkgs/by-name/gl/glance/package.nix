{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "glance";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "glance";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HFF1qiruz1SM9+g3xOKawuGmLzdYUUt3DnMRwjobVN4=";
  };

  vendorHash = "sha256-lURRHlZoxbuW1SXxrxy2BkMndcEllGFmVCB4pXBad8Q=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/glanceapp/glance/internal/glance.buildVersion=${finalAttrs.version}"
  ];

  excludedPackages = [ "scripts/build-and-ship" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      service = nixosTests.glance;
    };
  };

  meta = {
    homepage = "https://github.com/glanceapp/glance";
    changelog = "https://github.com/glanceapp/glance/releases/tag/v${finalAttrs.version}";
    description = "Self-hosted dashboard that puts all your feeds in one place";
    mainProgram = "glance";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dvn0
      defelo
    ];
  };
})
