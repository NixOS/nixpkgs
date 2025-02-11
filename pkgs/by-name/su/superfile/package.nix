{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "1.1.7.1";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-v7EfMgOsc6FSGIjYkF+44t0wl34WFmokOtzNOAOneBc=";
  };

  vendorHash = "sha256-MdOdQQZhiuOJtnj5n1uVbJV6KIs0aa1HLZpFmvxxsWY=";

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
