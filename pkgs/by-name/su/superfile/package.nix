{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "1.2.0.0";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-ByCKpNUWwVzO6A8Ad9V0P0lsquYgVqDS3eCta5iOfXI=";
  };

  vendorHash = "sha256-5mjy6Mu/p7UJCxn2XRbgtfGmrS+9bEt4+EVheYZcDpY=";

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
