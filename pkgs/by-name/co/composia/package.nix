{
  lib,
  buildGoModule,
  fetchFromForgejo,
}:

buildGoModule (finalAttrs: {
  pname = "composia";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.alexma.top";
    owner = "alexma233";
    repo = "composia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fca4lmjR2er+bfhI5yX3prL+02iFsaKfgmdTdaVeiOU=";
  };

  vendorHash = "sha256-LIts6L6jl2ZmHvOBboB9eBIf3VWraaVMca7/s7h65bU=";

  subPackages = "cmd/composia cmd/composia-controller cmd/composia-agent";

  ldflags = [
    "-s"
    "-w"
    "-X forgejo.alexma.top/alexma233/composia/internal/version.Value=${finalAttrs.version}"
  ];

  meta = {
    description = "Self-hosted Docker Compose control plane and CLI";
    homepage = "https://docs.composia.xyz";
    changelog = "https://forgejo.alexma.top/alexma233/composia/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ alexma233 ];
    mainProgram = "composia";
    platforms = lib.platforms.linux;
  };
})
