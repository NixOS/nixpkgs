{
  lib,
  buildGo125Module,
  fetchFromGitLab,
}:

buildGo125Module rec {
  pname = "gitlab-container-registry";
  version = "4.43.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-0PApwoqo2VrDhVOB5dVLLOlJiO6Y7I3HH5IueN8uAH0=";
  };

  vendorHash = "sha256-hJ/LUeaQkybW1ZGbCyv7rcC0WpOw6aHF1l8x6yVsNLo=";

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
