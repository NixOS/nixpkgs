{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mesos-dns";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "m3scluster";
    repo = "mesos-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-InUuEJjfZTRToCGiC3QYDK7UY8vje0T8RQ2YElIkb2w=";
  };

  vendorHash = "sha256-l1y3CaGG1ykJnGit81D+E+jB4RUYneQzRMTvOPCH+jk=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://m3scluster.github.io/mesos-dns/";
    changelog = "https://github.com/m3scluster/mesos-dns/releases/tag/v${finalAttrs.version}";
    description = "DNS-based service discovery for Mesos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mesos-dns";
  };
})
