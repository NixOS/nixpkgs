{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  __structuredAttrs = true;

  pname = "prometheus-rtorrent-exporter";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "aauren";
    repo = "rtorrent-exporter";
    rev = "v${version}";
    hash = "sha256-hlqlRTZGJ3kg4kvgmORGrhvQrUh4kFXl372LsqisE0U=";
  };

  vendorHash = "sha256-rIXqoGPgaP65yf8r4+n73+Ie0b5uiWCr/fo6YCZ1rGY=";

  ldflags = [
    "-X github.com/aauren/rtorrent-exporter/cmd.Version=v${version}"
    "-X github.com/aauren/rtorrent-exporter/cmd.BuildDate=1970-01-01T00:00:00Z"
  ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) rtorrent;
  };

  meta = {
    description = "Prometheus exporter for rTorrent";
    homepage = "https://github.com/aauren/rtorrent-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ananthb ];
    mainProgram = "rtorrent-exporter";
  };
}
