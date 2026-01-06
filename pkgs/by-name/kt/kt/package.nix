{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "kt";
  version = "13.1.0";

  src = fetchFromGitHub {
    owner = "fgeller";
    repo = "kt";
    rev = "v${version}";
    sha256 = "sha256-1UGsiMMmAyIQZ62hNIi0uzyX2uNL03EWupIazjznqDc=";
  };

  vendorHash = "sha256-PeNpDro6G78KLN6B2CDhsTKamRTWQyxPJYWuuv6sUyw=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "Kafka command line tool";
    homepage = "https://github.com/fgeller/kt";
    maintainers = with lib.maintainers; [ utdemir ];
    platforms = with lib.platforms; unix;
    license = lib.licenses.mit;
    mainProgram = "kt";
  };
}
