{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "credential-detector";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "ynori7";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-20ySTLpjTc1X0iJsbzbeLmWF0xYzzREGOqEWrB2X1GQ=";
  };

  vendorHash = "sha256-VWmfATUbfnI3eJbFTUp6MR1wGESuI15PHZWuon5M5rg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to detect potentially hard-coded credentials";
    mainProgram = "credential-detector";
    homepage = "https://github.com/ynori7/credential-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
