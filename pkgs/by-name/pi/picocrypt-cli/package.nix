{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "picocrypt-cli";
  version = "2.04";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    rev = version;
    hash = "sha256-LWU/u+5AJgBS9IAA3fq5jQLlst+kpEqtRZvjkBSMG2E=";
  };

  sourceRoot = "${src.name}/picocrypt";
  vendorHash = "sha256-5bdiXy/c4FYu544lyL/ac3KF/1zWIPG/bmrpdZa9YV8=";

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
