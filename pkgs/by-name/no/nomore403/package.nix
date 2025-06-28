{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nomore403";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = "nomore403";
    tag = version;
    hash = "sha256-qA1i8l2oBQQ5IF8ho3K2k+TAndUTFGwb2NfhyFqfKzU=";
  };

  vendorHash = "sha256-IGnTbuaQH8A6aKyahHMd2RyFRh4WxZ3Vx/A9V3uelRg=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Tool to bypass 403/40X response codes";
    homepage = "https://github.com/devploit/nomore403";
    changelog = "https://github.com/devploit/nomore403/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nomore403";
  };
}
