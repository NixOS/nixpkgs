{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "certstream-server-go";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "d-Rickyy-b";
    repo = "certstream-server-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mia5z/OwjTLsYbZ+IEV6vX2Q6Zu/vJIwGKpyOxZLmPM=";
  };

  vendorHash = "sha256-OHy5WRmq+Hv2p6KkgxuRtC1NJvpPgO+gS4ghF4MDEIE=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Drop-in replacement in Golang for the certstream server by Calidog";
    homepage = "https://github.com/d-Rickyy-b/certstream-server-go";
    changelog = "https://github.com/d-Rickyy-b/certstream-server-go/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "certstream-server-go";
  };
})
