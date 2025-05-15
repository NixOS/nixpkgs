{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "irccat";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "irccloud";
    repo = "irccat";
    rev = "v${version}";
    hash = "sha256-DwJTwpkb2/YHocUHhF0DwxEzDW6DLOxADda/Ed5Xg7c=";
  };

  patches = [
    # predeclared any requires go1.18 or later (-lang was set to go1.16; check go.mod)
    # https://github.com/irccloud/irccat/pull/38
    (fetchpatch {
      url = "https://github.com/irccloud/irccat/pull/38/commits/6bbe6e5762e93080f916a87a93aaeb90ec5fe12c.patch";
      hash = "sha256-1QsMxAOdZLT/ReDhaVzQtYiGejl5mOrTC58PQpIygIY=";
    })
  ];

  vendorHash = "sha256-SUE868jVJywqE0A5yjMWohrMw58OUnxGGxvcR8UzPfE=";

  meta = {
    homepage = "https://github.com/irccloud/irccat";
    changelog = "https://github.com/irccloud/irccat/releases/tag/v${version}0.4.11";
    description = "Send events to IRC channels from scripts and other applications";
    mainProgram = "irccat";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.gpl3Only;
  };
}
