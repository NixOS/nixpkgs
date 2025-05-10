{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mox";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "mjl-";
    repo = "mox";
    tag = "v${version}";
    hash = "sha256-apIV+nClXTUbmCssnvgG9UwpTNTHTe6FgLCxp14/s0A=";
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
