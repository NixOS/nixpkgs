{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "jsluice";
  version = "0-unstable-2023-06-23";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "jsluice";
    rev = "f10429e1016a9573da0157eacde8f7feb9deb8c7";
    hash = "sha256-l9rwC1ljtt7Q+FYKdQFhtnLJDS8OwMJXIIpZgya0zwU=";
  };

  vendorHash = "sha256-u4E+b/vChXArovtaZ4LODaINWit86i5K4GyHLR0JSyU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool for extracting URLs, paths, secrets, and other data from JavaScript source code";
    homepage = "https://github.com/BishopFox/jsluice";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
