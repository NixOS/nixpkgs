{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.5.6";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-h7k/zAYqpCAGn2dW+a3gOF/BN5ywjy/2Yx6THK9zk6k=";
  };

  vendorHash = "sha256-c7wU9LLRlS9kOhE4yAiKAs/npQe8lvSwPcd+/D8o9rk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/cmd.Version=v${version}"
  ];

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
