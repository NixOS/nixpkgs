{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  testers,
  centrifugo,
}:
let
  # Inspect build flags with `go version -m centrifugo`.
  statsEndpoint = "https://graphite-prod-01-eu-west-0.grafana.net/graphite/metrics,https://stats.centrifugal.dev/usage";
  statsToken =
    "425599:eyJrIjoi"
    + "OWJhMTcyZGNjN2FkYjEzM2E1OTQwZjIyMTU3MTBjMjUyYzAyZWE2MSIsIm4iOiJVc2FnZSBTdGF0cyIsImlkIjo2NDUzOTN9";
in
buildGoModule rec {
  pname = "centrifugo";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "centrifugal";
    repo = "centrifugo";
    rev = "v${version}";
    hash = "sha256-CuH8P28WMKBMHHXFZ1zyFX483zNlcomDGVP2CWtF4TM=";
  };

  vendorHash = "sha256-ug6P0xYN3bhmbDWu9MOL2OtDkm2IWjBZDrCOKjPXX3A=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/centrifugal/centrifugo/v6/internal/build.Version=${version}"
    "-X=github.com/centrifugal/centrifugo/v6/internal/build.UsageStatsEndpoint=${statsEndpoint}"
    "-X=github.com/centrifugal/centrifugo/v6/internal/build.UsageStatsToken=${statsToken}"
  ];

  excludedPackages = [
    "./internal/gen/api"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) centrifugo;
      version = testers.testVersion {
        package = centrifugo;
        command = "centrifugo version";
        version = "v${version}";
      };
    };
  };

  meta = {
    description = "Scalable real-time messaging server";
    homepage = "https://centrifugal.dev";
    changelog = "https://github.com/centrifugal/centrifugo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.tie
      lib.maintainers.valodim
    ];
    mainProgram = "centrifugo";
  };
}
