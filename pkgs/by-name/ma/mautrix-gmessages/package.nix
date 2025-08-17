{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-gmessages,
}:

buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    tag = "v${version}";
    hash = "sha256-AIw7Grh4BEDT33N4004XjOtIepguO2SbdUmTHGJ1A2M=";
  };

  vendorHash = "sha256-73a+OyauFJv2Rx6tbjwN9SBaXu4ZL5qM5xFt5m8a7c4=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${version}"
  ];

  buildInputs = [ olm ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mautrix-gmessages; };
  };

  meta = with lib; {
    description = "Matrix-Google Messages puppeting bridge";
    homepage = "https://github.com/mautrix/gmessages";
    changelog = "https://github.com/mautrix/gmessages/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ sumnerevans ];
    mainProgram = "mautrix-gmessages";
  };
}
