{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ots";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sniptt-official";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GOCuH9yiVs3N3sHCCoSGaQkaaJs4NY/klNBRWjZGLE4=";
  };

  vendorHash = "sha256-fLElExANWdPCCqpCAofqp0kba/FsQEHEhlxOFaC/kZw=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.buildSource=nix"
  ];

  meta = with lib; {
    description = "Share end-to-end encrypted secrets with others via a one-time URL";
    mainProgram = "ots";
    homepage = "https://ots.sniptt.com";
    changelog = "https://github.com/sniptt-official/ots/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elliot ];
  };
}
