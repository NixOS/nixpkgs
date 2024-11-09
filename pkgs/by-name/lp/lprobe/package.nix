{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "lprobe";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    rev = "refs/tags/v${version}";
    hash = "sha256-q7lH0aLgQNM4jrrrq2ua+pt4/VknxlzKzDH5J4MwjfA=";
  };

  vendorHash = "sha256-B3lcE33Ny+XE7nK/QlVcV8yYgzYWNBfoecuL+AcavSk=";

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
