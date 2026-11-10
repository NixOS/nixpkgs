{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "smokeping_prober";
  version = "0.12.0";

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
    sha256 = "sha256-bFKJkqeuVS4z4jylJ67UgL6OPyi/JbowMKn5/Feu6lM=";
  };
  vendorHash = "sha256-rNk9mCVpc2N+lLAarDenmOLy00swS1rkTNxMy62wR+k=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smokeping; };

  meta = {
    description = "Prometheus exporter for sending continual ICMP/UDP pings";
    mainProgram = "smokeping_prober";
    homepage = "https://github.com/SuperQ/smokeping_prober";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lukegb ];
  };
}
