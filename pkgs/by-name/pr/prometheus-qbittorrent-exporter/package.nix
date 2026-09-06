{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-qbittorrent-exporter";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "martabal";
    repo = "qbittorrent-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mPmoaqQp/TOryJxDm5/7hybBxEIn8TaSf/+KTNYmZOE=";
  };

  vendorHash = "sha256-vRAmGwguHq7b/85joMidgI8T/jGoONB48sX68U4bdp4=";

  ldflags = [
    "-s"
    "-X 'qbit-exp/app.version=v${finalAttrs.version}'"
  ];

  # Tests create a local http server
  __darwinAllowLocalNetworking = true;

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
