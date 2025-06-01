{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mesos-dns";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "m3scluster";
    repo = "mesos-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/zcjQ2AxZ17rAxrRmfztj5gH1pu2QswJgaCE022FieU=";
  };

  vendorHash = "sha256-TSw6ui5nGHRJiT/W+iszKA0rtgUIf73yDJaHkUgqowk=";

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
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "mesos-dns";
  };
})
