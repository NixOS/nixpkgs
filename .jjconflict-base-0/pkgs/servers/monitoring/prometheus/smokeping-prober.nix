{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "smokeping_prober";
  version = "0.10.0";

  ldflags =
    let
      setVars = rec {
        Version = version;
        Revision = "722200c4adbd6d1e5d847dfbbd9dec07aa4ca38d";
        Branch = Revision;
        BuildUser = "nix";
      };
      varFlags = lib.concatStringsSep " " (
        lib.mapAttrsToList (name: value: "-X github.com/prometheus/common/version.${name}=${value}") setVars
      );
    in
    [
      "${varFlags}"
      "-s"
      "-w"
    ];

  src = fetchFromGitHub {
    owner = "SuperQ";
    repo = "smokeping_prober";
    rev = "v${version}";
    sha256 = "sha256-dsdwXBTAPkMjaAWBjkNiJEaKi5cIcr1qctVDTuzmjAo=";
  };
  vendorHash = "sha256-anc4YtkfkPt8mXRZcVD8kQt2X2O3SCpRWPIqV4yz92E=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smokeping; };

  meta = with lib; {
    description = "Prometheus exporter for sending continual ICMP/UDP pings";
    mainProgram = "smokeping_prober";
    homepage = "https://github.com/SuperQ/smokeping_prober";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
  };
}
