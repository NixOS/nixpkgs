{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazydocker,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "lazydocker";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZZl0gt0gNjEI3JC96Xc29SZAyKh15jCuGHyEanIwNwY=";
  };

  vendorHash = null;

  postPatch = ''
    rm -f pkg/config/app_config_test.go
  '';

  excludedPackages = [
    "scripts"
    "test/printrandom"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = lazydocker;
  };

  meta = {
    description = "Simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      das-g
    ];
    mainProgram = "lazydocker";
  };
})
