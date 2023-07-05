{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  version = "0.0.11";
  pname = "prometheus-openweather-exporter";

  src = fetchFromGitHub {
    owner = "billykwooten";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X7N4mvx/WuLS58bgEAyMejKtjoDTVf9XFvopZdon89o=";
  };

  vendorHash = "sha256-J8kUiedKxFPtvH95I0Op1WWnIh18diWFVDff8GgShCo=";

  meta = {
    description = "Prometheus exporter utilizing Openweather API to gather weather metrics.";
    homepage = "https://github.com/billykwooten/openweather-exporter";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
