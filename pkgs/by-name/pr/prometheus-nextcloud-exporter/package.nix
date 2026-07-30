{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-inUdo7LVx5EreYnw/5UKGu1frIeK2fHnNPAAXowRCn4=";
  };

  vendorHash = "sha256-3HrJ1HtovA/GJJw96eQQTRnwzMUE4E24lVHc8rhZqzY=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nextcloud-exporter";
  };
}
