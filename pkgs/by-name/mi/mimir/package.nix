{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "mimir";
  version = "2.17.1";

  src = fetchFromGitHub {
    rev = "mimir-${version}";
    owner = "grafana";
    repo = "mimir";
    hash = "sha256-Ob0l+C5LnFL1yl76/cdSX83bHEcamPlb9Sau8rMO2sM=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/mimir"
    "cmd/mimirtool"
  ]
  ++ (map (pathName: "tools/${pathName}") [
    "compaction-planner"
    "copyblocks"
    "copyprefix"
    "delete-objects"
    "list-deduplicated-blocks"
    "listblocks"
    "mark-blocks"
    "splitblocks"
    "tenant-injector"
    "undelete-blocks"
  ]);

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "mimir-([0-9.]+)"
      ];
    };
    tests = {
      inherit (nixosTests) mimir;
    };
  };

  ldflags =
    let
      t = "github.com/grafana/mimir/pkg/util/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
    ];

  meta = with lib; {
    description = "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus. ";
    homepage = "https://github.com/grafana/mimir";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      happysalada
      bryanhonof
      adamcstephens
    ];
  };
}
