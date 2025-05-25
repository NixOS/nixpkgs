{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.22.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-r7IVX4xH/K+tfoEKfO9HITHUZT6yfBP2Zr6EPZQUxfw=";
  };

  vendorHash = "sha256-e7EIScdd0k5iFTDutFotNkKj1rKtBqfEexdkpjSHAoE=";

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
