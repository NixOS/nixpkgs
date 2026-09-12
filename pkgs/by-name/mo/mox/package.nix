{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mox";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "mjl-";
    repo = "mox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9zStO4bxiPUtL7e6h1Z/yDDALgYcIGI0CGoOQUok8Vc=";
  };

  # set the version during buildtime
  patches = [ ./version.patch ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mjl-/mox/moxvar.Version=${finalAttrs.version}"
    "-X github.com/mjl-/mox/moxvar.VersionBare=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern full-featured open source secure mail server for low-maintenance self-hosted email";
    mainProgram = "mox";
    homepage = "https://github.com/mjl-/mox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kotatsuyaki
    ];
    teams = with lib.teams; [ ngi ];
  };
})
