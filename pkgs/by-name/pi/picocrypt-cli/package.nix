{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "picocrypt-cli";
  version = "2.05";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    rev = version;
    hash = "sha256-9VvPgATij6WkOVaRDAmwjRshzPk6UCTlaiYJzceTHFQ=";
  };

  sourceRoot = "${src.name}/picocrypt";
  vendorHash = "sha256-UNyBDWdl9G8Rt3BLWZyuh1bv4jd9TZ9sOfUAgDPzjlw=";

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
