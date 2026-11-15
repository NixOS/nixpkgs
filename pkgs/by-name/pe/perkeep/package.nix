{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "perkeep";
  version = "0.12-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "perkeep";
    repo = "perkeep";
    rev = "257aaa416e0c99de48b743f08edb36bfe02b833a";
    hash = "sha256-dzrNRSZaN3/kYL4VPdqqfmnamytJZv1GmBggtaq9F3s=";
  };

  vendorHash = "sha256-2aYMoL3tre12GqUFJBwe1xYZyFt40d4S6oRzGPiGCfw=";

  ldflags = [
    "-s"
    "-w"
    "-X perkeep.org/pkg/buildinfo.GitInfo=v${finalAttrs.version}"
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
})
