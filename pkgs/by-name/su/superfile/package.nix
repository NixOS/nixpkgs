{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "1.2.1";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-yClDrDpt6QUWeAtWkG0tkmFqnaviRixz6Kez0q4cRuk=";
  };

  vendorHash = "sha256-STiuaNcmoviHBXGcSPPs39sICsks3Z8I3ANdnlUqA/k=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      momeemt
      redyf
    ];
    mainProgram = "superfile";
  };
}
