{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "prometheus-qbittorrent-exporter";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "martabal";
    repo = "qbittorrent-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ivHTGj2+6c23KW5aT5a8NFzUxV13u0y9UnHttZYTkuA=";
  };
  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-FHKt2QpvianVVbAJUcaou/+Ok69a8NbkM7ymVgxUi0I=";

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
