{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "mimir";
  version = "2.14.2";

  src = fetchFromGitHub {
    rev = "${pname}-${version}";
    owner = "grafana";
    repo = pname;
    hash = "sha256-y+87cMG9Ilyb99EeLp/UjIEl+5e1zyfoaFLW5i12gGY=";
  };

  vendorHash = null;

  subPackages =
    [
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
      "markblocks"
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
      ''-extldflags "-static"''
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
