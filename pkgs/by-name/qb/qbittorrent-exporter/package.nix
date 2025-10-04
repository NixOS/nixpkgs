{
  lib,
  fetchFromGitHub,
  buildGo125Module,
  nix-update-script,
}:
buildGo125Module rec {
  pname = "qbittorrent-exporter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "martabal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Rv1UuvWfQzHQ82ZKfLWnxhCWYhALy3CuLL6nUzeNugc=";
  };
  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-21/L4etH/xi3q69FCsYxAKui4PhPN1c+vZt3ZNnI0+8=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A fast and lightweight Prometheus exporter for qBittorrent.";
    homepage = "https://github.com/martabal/qbittorrent-exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ typedrat ];
    mainProgram = "qbit-exp";
  };
}
