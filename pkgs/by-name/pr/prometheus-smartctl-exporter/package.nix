{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  smartmontools,
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0WppsqDl4nKa6s/dyX9zsUzoqAgStDSBWMM0eolTPdk=";
  };

  vendorHash = "sha256-Sy/lm55NAhYDdVLli5yQpoRVieJU8RJDRFzd4Len6eg=";

  postPatch = ''
    substituteInPlace main.go README.md \
      --replace-fail /usr/sbin/smartctl ${lib.getExe smartmontools}
  '';

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smartctl; };

  meta = with lib; {
    description = "Export smartctl statistics for Prometheus";
    mainProgram = "smartctl_exporter";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      hexa
      Frostman
    ];
  };
}
