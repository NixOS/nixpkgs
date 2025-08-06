{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "lprobe";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    tag = "v${version}";
    hash = "sha256-Cb6jzL/BAhfwvGENLFfphATDz0EjFFT7qeHFiZCrvBk=";
  };

  vendorHash = "sha256-wQrbRch+5srZfQgEz7aacfbUXJfHeDCz52pPrgDFaNg=";

  buildInputs = [
    libpcap
  ];

  meta = {
    description = "Command-line tool to perform Local Health Check Probes inside Container Images (ECS, Docker)";
    homepage = "https://github.com/fivexl/lprobe";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cageyv ];
    mainProgram = "lprobe";
  };
}
