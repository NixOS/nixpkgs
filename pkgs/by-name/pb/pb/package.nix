{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  pb,
}:

buildGoModule rec {
  pname = "pb";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KedO/ngAlabuf3/NPKhutnzLphz6/VxJ+XJvADIP3PQ=";
  };

  vendorHash = "sha256-RAb2OvN3DF54fsVI5tRtNp1BYwB2qfYome7tj8zxxCY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  tags = [ "kqueue" ];

  passthru.tests.version = testers.testVersion {
    package = pb;
    command = "pb version";
  };

  meta = with lib; {
    homepage = "https://github.com/parseablehq/pb";
    changelog = "https://github.com/parseablehq/pb/releases/tag/v${version}";
    description = "CLI client for Parseable server";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "pb";
  };
}
