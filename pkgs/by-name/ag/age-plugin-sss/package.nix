{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "age-plugin-sss";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-sss";
    tag = "v${version}";
    hash = "sha256-ZcL1bty4qMWVl8zif9tAWFKZiTFklHxaAHESpapZ4WM=";
  };

  vendorHash = "sha256-Sr+6Tgbm7n8gQMqZng3kyzmpMgBZaIX1oEn6nV5c89U=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = {
    description = "Age plugin to split keys and wrap them with different recipients using Shamir's Secret Sharing";
    homepage = "https://github.com/olastor/age-plugin-sss/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "age-plugin-sss";
  };
}
