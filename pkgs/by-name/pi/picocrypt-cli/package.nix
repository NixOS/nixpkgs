{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "picocrypt-cli";
  version = "2.08";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    rev = version;
    hash = "sha256-6/VmacOXQOCkjLFyzDPyohOueF3WKJu7XCAD9oiFXEc=";
  };

  sourceRoot = "${src.name}/picocrypt";
  vendorHash = "sha256-QIeuqdoC17gqxFgKJ/IU024dgofBCizWTj2S7CCmED4=";

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
