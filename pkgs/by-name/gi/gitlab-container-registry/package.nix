{
  lib,
  buildGo124Module,
  fetchFromGitLab,
}:

buildGo124Module rec {
  pname = "gitlab-container-registry";
  version = "4.33.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-6FcnzlQQSeM8l2jH5dG9g0rmnEvAg2FWB8ZpKYBBhE4=";
  };

  vendorHash = "sha256-YfpqspLh+lV+MVZtn8iHQuE+DkZrcOq6hDt20SqkKfw=";

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
