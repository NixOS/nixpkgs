{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "picocrypt-cli";
  version = "2.06";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    rev = version;
    hash = "sha256-vxHYTgNVhTTN1yQkqjvlzqq7pV0XiQqTHI9HqIUVyR4=";
  };

  sourceRoot = "${src.name}/picocrypt";
  vendorHash = "sha256-Nuo4oIJxp+liNLNXRvbFTE1ElEIM1OBp5CTb0KEV/7g=";

  ldflags = [
    "-s"
    "-w"
  ];

  CGO_ENABLED = 1;

  meta = {
    description = "Command-line interface for Picocrypt";
    homepage = "https://github.com/Picocrypt/CLI";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "picocrypt";
  };
}
