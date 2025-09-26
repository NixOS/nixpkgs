{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    tag = "v${version}";
    hash = "sha256-8NEZH+a1HBQ7lVcJlIEaeDjFU8c+4Zm6JOe0IiK0nIU=";
  };

  cargoHash = "sha256-ro+vlkuX2eZ6Sh8uW/0ZZJnl8YqW7Yij+6xneQMDpEQ=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
