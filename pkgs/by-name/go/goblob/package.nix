{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goblob";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Macmod";
    repo = "goblob";
    tag = "v${version}";
    hash = "sha256-FnSlfLi40VwDyQY77PvhV7EbhUDs1uGx0VsgP8HgKTw=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Enumeration tool for publicly exposed Azure Storage blobs";
    mainProgram = "goblob";
    homepage = "https://github.com/Macmod/goblob";
    changelog = "https://github.com/Macmod/goblob/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
