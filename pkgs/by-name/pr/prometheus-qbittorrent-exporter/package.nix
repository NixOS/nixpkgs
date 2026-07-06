{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-qbittorrent-exporter";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "martabal";
    repo = "qbittorrent-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bVfYDIT3FMCFs/p+fFwm+xKiqbffPJ26Z2KFmBlqMjg=";
  };

  vendorHash = "sha256-vw4uwQt/PI8yl81NC3wAdgCiPacg/Pmv2MNlnR9Y/v0=";

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
