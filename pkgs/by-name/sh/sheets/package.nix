{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sheets";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "sheets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P+Teehs0LE4drbTPBvz3BNKCSKhQVR/QezsHxpWysDY=";
  };

  vendorHash = "sha256-WWtAt0+W/ewLNuNgrqrgho5emntw3rZL9JTTbNo4GsI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Terminal based spreadsheet tool";
    homepage = "https://github.com/maaslalani/sheets";
    changelog = "https://github.com/maaslalani/sheets/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.maaslalani ];
    mainProgram = "sheets";
  };
})
