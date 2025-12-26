{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "albedo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "albedo";
    tag = "v${version}";
    hash = "sha256-H/ViMVzuuQYORDiNXBgs7imy+c4IaL2pY5KVN6ecJoo=";
  };

  vendorHash = "sha256-FBkHpTn4jG6iw1GYAuGHh2WCRro4mRgumYoGMkmv6qU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "HTTP reflector and black hole";
    homepage = "https://github.com/coreruleset/albedo";
    changelog = "https://github.com/coreruleset/albedo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "albedo";
  };
}
