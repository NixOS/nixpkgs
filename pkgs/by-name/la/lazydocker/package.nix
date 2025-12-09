{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazydocker,
  testers,
}:

buildGoModule rec {
  pname = "lazydocker";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "sha256-Dw7FBJ78b835iVkV8OrA06CAZ/GRCEXlLg/RfHZXfF0=";
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
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = lazydocker;
  };

  meta = with lib; {
    description = "Simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = licenses.mit;
    maintainers = with maintainers; [
      das-g
    ];
    mainProgram = "lazydocker";
  };
}
