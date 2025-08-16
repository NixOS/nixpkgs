{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.26.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-XACKJW5sRXNM4Q24DXEVtjzhVfxoBd+JWHJr1s01ocA=";
  };

  patches = [
    # https://gitlab.com/gitlab-org/container-registry/-/merge_requests/2447
    # Can be removed with next released when merged
    ./fix-broken-urlcache-tests.diff
  ];

  vendorHash = "sha256-J4p3vXLmDFYl/z6crqanlmG1FB4Dq04HLx9IhC3usQ4=";

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
