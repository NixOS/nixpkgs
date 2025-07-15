{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fingerprintx";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "fingerprintx";
    tag = "v${version}";
    hash = "sha256-kbSP/nSdCrcEYVvLVawjZ2RDvTGv5JsHEIXXcPLA1ng=";
  };

  vendorHash = "sha256-1KSNvK2ylqWjfhxMY+NQFoDahPgqGb12nA4oGqqoFIA=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Standalone utility for service discovery on open ports";
    mainProgram = "fingerprintx";
    homepage = "https://github.com/praetorian-inc/fingerprintx";
    changelog = "https://github.com/praetorian-inc/fingerprintx/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
