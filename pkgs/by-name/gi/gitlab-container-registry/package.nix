{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.42.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-PUyQRdDD+0YeHGqol5E7hg9rYZIWIV+APGdmJnlbwtg=";
  };

  vendorHash = "sha256-RH3x6Zc1S3U4iFxA7rAgYwm1f5lShlBmSvV0IAVo0c4=";

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
    homepage = "https://gitlab.com/gitlab-org/container-registry";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ e1mo ];
    teams = with lib.teams; [ gitlab ];
    platforms = lib.platforms.unix;
    mainProgram = "registry";
  };
}
