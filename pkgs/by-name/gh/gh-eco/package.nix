{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fetchpatch,
}:
let
  version = "0.1.3";
in
buildGoModule {
  pname = "gh-eco";
  inherit version;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "gh-eco";
    rev = "refs/tags/v${version}";
    hash = "sha256-TE1AymNlxjUtkBnBO/VBjYaqLuRyxL75s6sMidKUXTE=";
  };

  patches = [
    # Fix package breaking on runtime by updating deps
    (fetchpatch {
      name = "update-deps.patch";
      url = "https://github.com/jrnxf/gh-eco/commit/d45b1e7de8cbcb692def0e94111262cdeff2835d.patch";
      hash = "sha256-vW5YX6C552dVYjBkYVoDbzT2PP8CaZzxh5g1TKHjrbU=";
    })
  ];

  vendorHash = "sha256-O3FQ+Z3KVYgTafwVXUhrGRuOAWlWlOhtVegKVoZBnDE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    homepage = "https://github.com/coloradocolby/gh-eco";
    description = "gh extension to explore the ecosystem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ helium ];
    mainProgram = "gh-eco";
  };
}
