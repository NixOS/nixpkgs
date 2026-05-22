{
  lib,
  buildGo125Module,
  fetchFromGitLab,
}:

buildGo125Module rec {
  pname = "gitlab-container-registry";
  version = "4.39.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-7dGKV2Pc3OPdM4OZqYjp3B9/s6DHtPvrqcWnWb3wHYw=";
  };

  vendorHash = "sha256-s08LsgYZTRJm0sWkbEUsmTYGkfb/5PJl9o9ozY1KOms=";

  excludedPackages = [
    "devvm/*"
  ];

  checkFlags =
    let
      skippedTests = [
        # requires internet
        "TestHTTPChecker"
        # requires s3 credentials/urls
        "TestS3DriverPathStyle"
        # flaky
        "TestPurgeAll"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "GitLab Docker toolset to pack, ship, store, and deliver content";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ e1mo ];
    teams = with lib.teams; [ gitlab ];
    platforms = lib.platforms.unix;
    mainProgram = "registry";
  };
}
