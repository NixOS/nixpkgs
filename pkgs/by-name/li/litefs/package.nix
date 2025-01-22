{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "litefs";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I12bKImZkvAMyfwb6r/NxE+BcUk+SalN+cIDXP0q4xA=";
  };

  vendorHash = "sha256-FcYPe4arb+jbxj4Tl6bRRAnkEvw0rkECIo8/zC79lOA=";

  subPackages = [ "cmd/litefs" ];

  # following https://github.com/superfly/litefs/blob/main/Dockerfile
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-extldflags=-static"
  ];

  tags = [
    "osusergo"
    "netgo"
    "sqlite_omit_load_extension"
  ];

  doCheck = false; # fails

  meta = with lib; {
    description = "FUSE-based file system for replicating SQLite databases across a cluster of machines";
    homepage = "https://github.com/superfly/litefs";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "litefs";
  };
}
