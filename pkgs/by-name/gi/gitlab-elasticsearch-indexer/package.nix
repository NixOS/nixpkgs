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
  version = "5.9.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-Xt22fyTM4rfqUpNE6Q3yfT9r4vqME3KmqxYCqUKmnLQ=";
  };

  vendorHash = "sha256-pY8hHFy0AxMwol00BN85jPR0ZnHVgno10Tp+Opz65tQ=";

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
