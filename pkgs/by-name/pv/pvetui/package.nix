{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pvetui";
  version = "1.4.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devnullvoid";
    repo = "pvetui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v17/26uqZ5481qYxJpljehse0mUq1uTS3Vdm+NFnONI=";
  };

  vendorHash = "sha256-WJhQVt+UZj5N+P6spH9soS2UMnaWt2/rj1juiMF6fWU=";

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
