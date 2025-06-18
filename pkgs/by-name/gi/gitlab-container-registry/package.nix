{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.23.1";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-eCuSuQXtzd2jLJf9G8DO1KGXdT8bYGe9tcKw6BZNiiI=";
  };

  vendorHash = "sha256-OrdlQp+USRf+Yc7UDjIncDpbuRu5ui6TUoYY2MMc8Ro=";

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
