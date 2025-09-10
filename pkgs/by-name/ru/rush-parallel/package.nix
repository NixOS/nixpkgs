{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rush-parallel";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${version}";
    hash = "sha256-5xuRA3Jf9SiNc6E/XBP9PCSA7vmioww0G5QkUAzHmEI=";
  };

  vendorHash = "sha256-zCloMhjHNkPZHYX1e1nx072IYbWHFWam4Af0l0s8a6M=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Cross-platform command-line tool for executing jobs in parallel";
    homepage = "https://github.com/shenwei356/rush";
    changelog = "https://github.com/shenwei356/rush/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "rush-parallel";
  };
}
