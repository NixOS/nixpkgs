{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, nixosTests
, testers
, centrifugo
}:
let
  # Inspect build flags with `go version -m centrifugo`.
  statsEndpoint = "https://graphite-prod-01-eu-west-0.grafana.net/graphite/metrics,https://stats.centrifugal.dev/usage";
  statsToken = "425599:eyJrIjoi" +
    "OWJhMTcyZGNjN2FkYjEzM2E1OTQwZjIyMTU3MTBjMjUyYzAyZWE2MSIsIm4iOiJVc2FnZSBTdGF0cyIsImlkIjo2NDUzOTN9";
in
buildGoModule rec {
  pname = "centrifugo";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "centrifugal";
    repo = "centrifugo";
    rev = "v${version}";
    hash = "sha256-sSEainZXgZ26u4J0FXVM8Je1uwDrAOkzLMgrCUtOx74=";
  };

  vendorHash = "sha256-kPnkuBOcTDuAWD51JGJvgHLj9jn9kHZOfPw/DF64Mn8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/centrifugal/centrifugo/v5/internal/build.Version=${version}"
    "-X=github.com/centrifugal/centrifugo/v5/internal/build.UsageStatsEndpoint=${statsEndpoint}"
    "-X=github.com/centrifugal/centrifugo/v5/internal/build.UsageStatsToken=${statsToken}"
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
        command = "${pname} version";
        version = "v${version}";
      };
    };
  };

  meta = {
    description = "Scalable real-time messaging server";
    homepage = "https://centrifugal.dev";
    changelog = "https://github.com/centrifugal/centrifugo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tie ];
    mainProgram = "centrifugo";
  };
}
