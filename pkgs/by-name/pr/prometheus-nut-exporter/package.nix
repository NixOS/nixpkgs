{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nut-exporter";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-et1XCKpjyhr7yY24t8xBSRzh9nAmIG6bdjgbI1LuJaE=";
  };

  vendorHash = "sha256-cMZ4GSal03LIZi7ESr/sQx8zLHNepOTZGEEsdvsNhec=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nut; };

  meta = {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jhh ];
  };
}
