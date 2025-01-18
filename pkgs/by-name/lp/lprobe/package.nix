{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "lprobe";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    tag = "v${version}";
    hash = "sha256-WC0MDTyd5tRtSQ1LQsYJgV9CwJwtvnIO6tQnPrjpfcY=";
  };

  vendorHash = "sha256-Ot9eePv/bjOZJfOjTCOJGXCaM8hoO4ZUPrpec8lT/JY=";

  buildInputs = [
    libpcap
  ];

  meta = with lib; {
    description = "A command-line tool to perform Local Health Check Probes inside Container Images (ECS, Docker)";
    homepage = "https://github.com/fivexl/lprobe";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ cageyv ];
    mainProgram = "lprobe";
  };
}
