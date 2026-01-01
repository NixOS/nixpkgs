{
  lib,
  buildGoModule,
  fetchFromGitHub,
  lazydocker,
  testers,
}:

buildGoModule rec {
  pname = "lazydocker";
<<<<<<< HEAD
  version = "0.24.3";
=======
  version = "0.24.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-JbiG3cy+nn9BWJxX43YW+FKmWvsJPtRZ9NdMHtulzcw=";
=======
    sha256 = "sha256-Dw7FBJ78b835iVkV8OrA06CAZ/GRCEXlLg/RfHZXfF0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      das-g
=======
  meta = with lib; {
    description = "Simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = licenses.mit;
    maintainers = with maintainers; [
      das-g
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    mainProgram = "lazydocker";
  };
}
