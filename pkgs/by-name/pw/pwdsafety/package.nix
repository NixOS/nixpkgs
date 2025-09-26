{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pwdsafety";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pwdsafety";
    tag = "v${version}";
    hash = "sha256-qFYy22d8DqzsphdO1pCYiIKf1P2yQ4w+R1+K2sHI2kk=";
  };

  vendorHash = "sha256-CUwgAkCYc3U86QJo4RyWGqTYdx21Ysct0HBnU9w4YyU=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Command line tool checking password safety";
    homepage = "https://github.com/edoardottt/pwdsafety";
    changelog = "https://github.com/edoardottt/pwdsafety/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pwdsafety";
  };
}
