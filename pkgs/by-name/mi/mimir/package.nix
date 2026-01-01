{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "mimir";
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "3.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    rev = "mimir-${finalAttrs.version}";
    owner = "grafana";
    repo = "mimir";
<<<<<<< HEAD
    hash = "sha256-tYGzU/sn6KLLetDmAyph5u8bCocmfF4ZysTkOCSVf+U=";
=======
    hash = "sha256-eLdlfGz5OQ3bPWhO2niBynaIPtxXg3x2qD89VK7uuA0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
    ];

<<<<<<< HEAD
  meta = {
    description = "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus. ";
    homepage = "https://github.com/grafana/mimir";
    changelog = "https://github.com/grafana/mimir/releases/tag/mimir-${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus. ";
    homepage = "https://github.com/grafana/mimir";
    changelog = "https://github.com/grafana/mimir/releases/tag/mimir-${finalAttrs.version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      happysalada
      bryanhonof
      adamcstephens
    ];
  };
})
