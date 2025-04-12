{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "metabigor";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = "metabigor";
    rev = "refs/tags/v${version}";
    hash = "sha256-JFt9PC6VHWTYuaIWh2t2BiGFm1tGwZDdhhdp2xtmXSI=";
  };

  vendorHash = "sha256-PGUOTEFcOL1pG+itTp9ce1qW+1V6hts8jKpA0E8orDk=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = with lib; {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    changelog = "https://github.com/j3ssie/metabigor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "metabigor";
  };
}
