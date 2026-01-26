{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "scilla";
    tag = "v${version}";
    hash = "sha256-0aqcFtyi3cNiBelSTf8bwgxhErIDdXOI9c6FKT/Omlw=";
  };

  vendorHash = "sha256-0DDBvoJiHXka90gvcyxnldJJWvb8dfBFwRjHJO4pFGA=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    # requires network access
    "-skip=TestIPToHostname"
  ];

  meta = {
    description = "Information gathering tool for DNS, ports and more";
    mainProgram = "scilla";
    homepage = "https://github.com/edoardottt/scilla";
    changelog = "https://github.com/edoardottt/scilla/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
