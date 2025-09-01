{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "passdetective";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "aydinnyunus";
    repo = "PassDetective";
    rev = version;
    hash = "sha256-ln+nKESCYNQwTB6njNQBNUGmF+NXqgzmM1sb/d6ZBcU=";
  };

  vendorHash = "sha256-4FF0aQiuVN382RBCYI7SpoB8U8MZoXTomuFEvcbcREg=";

  ldflags = [
    "-s"
    "-w"
    "-extldflags"
    "-static"
    "-X=main.build=${version}"
  ];

  meta = {
    description = "Scans command history to detect mistakenly written passwords, API keys, and secrets";
    homepage = "https://github.com/aydinnyunus/PassDetective";
    changelog = "https://github.com/aydinnyunus/PassDetective/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "PassDetective";
  };
}
