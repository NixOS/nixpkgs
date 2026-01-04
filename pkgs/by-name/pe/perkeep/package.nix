{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "perkeep";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "perkeep";
    repo = "perkeep";
    rev = "v${version}";
    hash = "sha256-mAVzgHDtCCYTds65qKzIJ+oqLbUQhhSdp6Sq0DA8zOA=";
  };

  vendorHash = "sha256-FLRfpyYVoZgV5LS2DjLOnc28Z+1v/YAxwWrOPoIzHHk=";

  ldflags = [
    "-s"
    "-w"
    "-X perkeep.org/pkg/buildinfo.GitInfo=v${version}"
  ];

  subPackages = [
    "server/perkeepd"
    "cmd/pk"
    "cmd/pk-get"
    "cmd/pk-put"
    "cmd/pk-mount"
  ];

  meta = {
    description = "Way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = "https://perkeep.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      gador
    ];
  };
}
