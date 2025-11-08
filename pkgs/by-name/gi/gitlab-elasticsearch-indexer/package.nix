{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
}:
let
  codeParserBindings = callPackage ./code-parser.nix { };
in
buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.9.4";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-Vj3QqskgrQIMF9mNY8WzvHL0KCU9Ebr3eDm4mUwQJL0=";
  };

  vendorHash = "sha256-nmgRQwjf6F7IkED0S7Q03T6Wad5sEmYLbBHLyA33WjU=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  env = {
    CGO_LDFLAGS = "-L${codeParserBindings}/lib";
    CGO_CFLAGS = "-I${codeParserBindings}/include";
  };

  passthru = {
    inherit codeParserBindings;
  };

  meta = with lib; {
    description = "Indexes Git repositories into Elasticsearch for GitLab";
    mainProgram = "gitlab-elasticsearch-indexer";
    license = licenses.mit;
    maintainers = with maintainers; [ yayayayaka ];
    teams = [ teams.cyberus ];
  };
}
