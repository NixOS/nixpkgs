{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hjson-go";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fonPxk/9ue8LzHTdKpuHJcucQoMl4P6gq+tbjS8Ui7Q=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Utility to convert JSON to and from HJSON";
    homepage = "https://hjson.github.io/";
    changelog = "https://github.com/hjson/hjson-go/releases/tag/v${version}";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.mit;
    mainProgram = "hjson-cli";
  };
}
