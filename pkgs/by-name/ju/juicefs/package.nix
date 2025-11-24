{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = "juicefs";
    rev = "v${version}";
    hash = "sha256-JQckOEoM40K5Tlq1Ti/vBIDdKqrtfnfy3JeJmp9K93o=";
  };

  vendorHash = "sha256-LE6bpFSHhIRKaGlgn8nU8leOfcNH1ruKRv3vHZu0n/s=";

  excludedPackages = [ "sdk/java/libjfs" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/juicedata/juicefs/pkg/version.version=${version}"
  ];

  doCheck = false; # requires network access

  postInstall = ''
    ln -s $out/bin/juicefs $out/bin/mount.juicefs
  '';

  meta = with lib; {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
