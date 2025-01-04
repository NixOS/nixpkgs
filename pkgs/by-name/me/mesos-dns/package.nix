{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mesos-dns";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "m3scluster";
    repo = "mesos-dns";
    rev = "v${version}";
    hash = "sha256-6uuaSCPBY+mKfU2Xku9M1oF5jwxogR2Rki4AIdsjLr0=";
  };

  vendorHash = "sha256-k47kxdkwhf9b8DdvWzwhj12ebvPYezxyIJ8w1Zn+Xew=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://m3scluster.github.io/mesos-dns/";
    changelog = "https://github.com/m3scluster/mesos-dns/releases/tag/v${version}";
    description = "DNS-based service discovery for Mesos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "mesos-dns";
  };
}
