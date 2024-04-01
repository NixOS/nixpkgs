{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.64.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-fkO7wcWivQ1do+KYQJe3OX+WN/jS3cd4pYsZUHojfiU=";
  };

  vendorHash = "sha256-RWB2sq3uNRrxGdBzKI03diaa5fF6LvglUV8L4Nz4fyk=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "api-linter";
  };
}
