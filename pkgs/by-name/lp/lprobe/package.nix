{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "lprobe";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    tag = "v${version}";
    hash = "sha256-1VoZIZQDEYVQg8cMacpHPRUffu+1+bAt7O3MZSi6+2A=";
  };

  vendorHash = "sha256-wrxIHb296YOszgK9GnCTpSHz2kSd89zT/90/CrPely8=";

  buildInputs = [
    libpcap
  ];

  meta = {
    description = "A command-line tool to perform Local Health Check Probes inside Container Images (ECS, Docker)";
    homepage = "https://github.com/fivexl/lprobe";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cageyv ];
    mainProgram = "lprobe";
  };
}
