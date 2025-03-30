{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mox";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "mjl-";
    repo = "mox";
    tag = "v${version}";
    hash = "sha256-cBTY4SjQxdM5jXantLws1ckGVn3/b0/iVPFunBy09YQ=";
  };

  # set the version during buildtime
  patches = [ ./version.patch ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mjl-/mox/moxvar.Version=${version}"
    "-X github.com/mjl-/mox/moxvar.VersionBare=${version}"
  ];

  meta = {
    description = "Modern full-featured open source secure mail server for low-maintenance self-hosted email";
    mainProgram = "mox";
    homepage = "https://github.com/mjl-/mox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      kotatsuyaki
    ];
  };
}
