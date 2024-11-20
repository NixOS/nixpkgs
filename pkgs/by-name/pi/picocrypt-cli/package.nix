{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "picocrypt-cli";
  version = "2.09";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    rev = version;
    hash = "sha256-DV+L3s479PqSiqi2xigZWwXVNCdkayD0wCpnlR0TljY=";
  };

  sourceRoot = "${src.name}/picocrypt";
  vendorHash = "sha256-F+t/VL9IzBfz8cfpaw+aEPxTPGUq3SbWbyqPWeLrh6E=";

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
