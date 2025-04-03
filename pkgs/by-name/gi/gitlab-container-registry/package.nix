{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.19.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-WrijK/kQugCpiDbMw1+QTvG60SDsdJ5PDFGKGiLBsb8=";
  };

  vendorHash = "sha256-0fvjnEm4NdIKexjTO/GijWy8WwBrLt3jZCwjfOKI4jA=";

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

  meta = with lib; {
    description = "GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers =
      with maintainers;
      [
        leona
        yayayayaka
      ]
      ++ teams.cyberus.members;
    platforms = platforms.unix;
  };
}
