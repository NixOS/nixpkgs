{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bucketloot";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "redhuntlabs";
    repo = "BucketLoot";
    tag = "v${version}";
    hash = "sha256-4nH2OpRgFJFi7PqxQgQbUM7gCh8XHWZ6M4LHlVRkywM=";
  };

  vendorHash = "sha256-4lAi6Rz3d98NT4Omqjbs8xnrmCCzY24oVddUneegN0A=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Automated S3-compatible bucket inspector";
    homepage = "https://github.com/redhuntlabs/BucketLoot";
    changelog = "https://github.com/redhuntlabs/BucketLoot/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bucketloot";
  };
}
