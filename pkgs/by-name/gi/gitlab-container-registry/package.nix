{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "4.17.1";
  rev = "v${version}-gitlab";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    hash = "sha256-zsrNu1Xdi2143i9po8UzEOtidwWjRlR5n0bOksz75FE=";
  };

  vendorHash = "sha256-I/umXgVm9a+0Ay3ARuaa4Dua4Zhc5p2TONHvhCt3Qtk=";

  checkFlags = [
    # TestHTTPChecker requires internet
    # TestS3DriverPathStyle requires s3 credentials/urls
    "-skip TestHTTPChecker|TestS3DriverPathStyle"
  ];

  meta = with lib; {
    description = "GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = with maintainers; [ yayayayaka ] ++ teams.cyberus.members;
    platforms = platforms.unix;
  };
}
