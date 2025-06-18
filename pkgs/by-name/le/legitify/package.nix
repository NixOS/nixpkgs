{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "legitify";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "Legit-Labs";
    repo = "legitify";
    tag = "v${version}";
    hash = "sha256-ijW0vvamuqcN6coV5pAtmjAUjzNXxiqr2S9EwrNlrJc=";
  };

  vendorHash = "sha256-QwSh7+LuwdbBtrIGk3ZK6cMW9h7wzNArPT/lVZgUGBU=";

  ldflags = [
    "-w"
    "-s"
    "-X=github.com/Legit-Labs/legitify/internal/version.Version=${version}"
  ];

  preCheck = ''
    rm e2e/e2e_test.go # tests requires network
  '';

  meta = {
    description = "Tool to detect and remediate misconfigurations and security risks of GitHub assets";
    homepage = "https://github.com/Legit-Labs/legitify";
    changelog = "https://github.com/Legit-Labs/legitify/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "legitify";
  };
}
