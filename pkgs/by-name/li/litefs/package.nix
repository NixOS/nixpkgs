{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "litefs";
  version = "0.5.14";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "litefs";
    rev = "v${version}";
    sha256 = "sha256-URwHnOvvz/UnrxoFIuUYpw10uPHgxQf9LPO1xECixDE=";
  };

  vendorHash = "sha256-i0gYhPwcs3dfWy6GANlUl1Nc+dXD8KuAT71FATwxpDo=";

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
