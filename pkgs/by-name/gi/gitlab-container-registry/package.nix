{
  lib,
  buildGo124Module,
  fetchFromGitLab,
}:

buildGo124Module rec {
  pname = "gitlab-container-registry";
  version = "4.28.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-0v39mQ0wLq2VUYNeDU6E2M8Ny/e/A3VrE8+pmpwJgug=";
  };

  vendorHash = "sha256-tCOXSZjJOWHTIdWYxdBaH6STKAwqlHsuDfhGd2KPx1Q=";

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

  meta = with lib; {
    description = "GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    teams = with teams; [
      gitlab
      cyberus
    ];
    platforms = platforms.unix;
  };
}
