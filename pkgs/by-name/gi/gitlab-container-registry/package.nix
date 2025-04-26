{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchpatch,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.20.0";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-irMMOjORJY8yVSNBkh7HDYDJv05RDz19f0KAjnF8EWA=";
  };

  vendorHash = "sha256-3j58QVLgwjUGX0QzruAbfRNyFmcAD5EApQ3+f212IDU=";

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
    maintainers = with maintainers; [ yayayayaka ] ++ teams.cyberus.members;
    platforms = platforms.unix;
  };
}
