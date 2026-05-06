{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule {
  __structuredAttrs = true;
  pname = "prometheus-speedtest-exporter";
  version = "0.0.5-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "podocarp";
    repo = "speedtest_exporter";
    rev = "e82be2ecb5d0cbcd5a6a21909afed6991b5d7e00";
    hash = "sha256-7uy1rVll7YzM9WeQQKKSiI4nblIPADD6h/5z/diCH4E=";
  };

  vendorHash = "sha256-w113vWnXM4h3zckmj39Qx/oZFaH9Mq0xUSqNxopdQO0=";

  meta = {
    description = "Speedtest.net Exporter for the Prometheus monitoring system";
    mainProgram = "speedtest_exporter";
    homepage = "https://github.com/danopstech/speedtest_exporter";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
