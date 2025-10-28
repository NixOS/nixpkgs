{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-qbittorrent-exporter";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "martabal";
    repo = "qbittorrent-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9J4nGG52M7SSeXigLBJK/dqXRvSpPqOGRJ8BQx7+1eU=";
  };
  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-jJmhRnjioeTq9Uol0lYLChPi4O1D9JnGqN7q1XK36yE=";

  ldflags = [
    "-s"
    "-X 'qbit-exp/app.version=v${finalAttrs.version}'"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for qBittorrent";
    homepage = "https://github.com/martabal/qbittorrent-exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      typedrat
      undefined-landmark
    ];
    mainProgram = "qbit-exp";
  };
})
