{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "superfile";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    rev = "v${version}";
    hash = "sha256-p5rTwGgiVdZoUWg6PYcmDlfED4/Z6+3lR4VBdWaaz9Q=";
  };

  vendorHash = "sha256-MdOdQQZhiuOJtnj5n1uVbJV6KIs0aa1HLZpFmvxxsWY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${src.rev}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      momeemt
      redyf
    ];
    mainProgram = "superfile";
  };
}
