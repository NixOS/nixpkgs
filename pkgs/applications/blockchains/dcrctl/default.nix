{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dcrctl";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrctl";
    rev = "release-v${version}";
    hash = "sha256-Nm1r3hHTlW5ob2CLKUgMjVsdzR2gxlFuT6Q3j0pPDSg=";
  };

  vendorHash = "sha256-Ry3wR2u+vr97icP9jwAVWcFO98JVDo9TrDg9D8hfv5I=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://decred.org";
    description = "A secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "dcrctl";
  };
}
