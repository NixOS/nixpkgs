{
  lib,
  buildGoModule,
  fetchFromGitHub,
  bash,
  nixosTests,
}:

buildGoModule rec {
  pname = "rtl_433-exporter";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "mhansen";
    repo = "rtl_433_prometheus";
    rev = "v${version}";
    hash = "sha256-ggtGi1gnpTLGvZnfAW9vyYyU7ELbTRNhXyCMotx+KKU=";
  };

  postPatch = "substituteInPlace rtl_433_prometheus.go --replace /bin/bash ${bash}/bin/bash";

  vendorHash = "sha256-BsNB0OTwBUu9kK+lSN7EF8ZQH3kFx8P9h4QgcfCvtg4=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) rtl_433; };

  meta = {
    description = "Prometheus time-series DB exporter for rtl_433 433MHz radio packet decoder";
    mainProgram = "rtl_433_prometheus";
    homepage = "https://github.com/mhansen/rtl_433_prometheus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zopieux ];
  };
}
