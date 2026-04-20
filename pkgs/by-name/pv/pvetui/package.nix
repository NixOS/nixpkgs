{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pvetui";
  version = "1.3.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devnullvoid";
    repo = "pvetui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PgxhfDFP0DBrihtkIWFYEOTbXUvp/WuB47iNPHJGr1Q=";
  };

  vendorHash = "sha256-gGhEW9owJYjI+59X/yJ+tta9AQh9hoBdOBaO5Rojdy8=";

  subPackages = [ "cmd/pvetui" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/devnullvoid/pvetui/internal/version.version=${finalAttrs.version}"
    "-X github.com/devnullvoid/pvetui/internal/version.commit=${finalAttrs.src.tag}"
    "-X github.com/devnullvoid/pvetui/internal/version.buildDate=1970-01-01T00:00:00Z"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI for Proxmox Virtual Environment";
    homepage = "https://pvetui.org/";
    changelog = "https://github.com/devnullvoid/pvetui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
    mainProgram = "pvetui";
  };
})
