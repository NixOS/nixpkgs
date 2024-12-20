{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-l9exOq8QF3WSQ/+WQr0NfPeRQ/R6VQwfT+YS76BBwd8=";
  };

  vendorHash = "sha256-sTzjTKQ9m5BicDk6M1wR1EU+o9+87DbHCyGoF35Jm/g=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=unknown"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Easily create & extract archives, and compress & decompress files of various formats";
    homepage = "https://github.com/mholt/archiver";
    mainProgram = "arc";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
