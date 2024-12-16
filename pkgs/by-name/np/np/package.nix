{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "np";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "leesoh";
    repo = "np";
    rev = "refs/tags/v${version}";
    hash = "sha256-4krjQi/zEC4a+CjacgbnQIMKKFVr6H2FSwRVB6pkHf0=";
  };

  vendorHash = "sha256-rSg4YFLZdtyC/tm/EULyt7r0O9PXI72W8y6/ltDSbj4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to parse, deduplicate, and query multiple port scans";
    homepage = "https://github.com/leesoh/np";
    changelog = "https://github.com/leesoh/np/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "np";
  };
}
