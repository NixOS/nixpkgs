{
  lib,
  buildGo125Module,
  fetchFromGitLab,
}:

buildGo125Module rec {
  pname = "gitlab-container-registry";
  version = "4.40.2";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-k94uEM2VoOtdFRXWm6CDmeRt8LMXSNegRGes3ZKPg0I=";
  };

  vendorHash = "sha256-MD98JYwTo/t5/E7clIlUfjmv8t7nDPpVElbuYDRjMMc=";

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
