{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "foxmarks";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "zer0-x";
    repo = "foxmarks";
    rev = "v${version}";
    hash = "sha256-6lJ9acVo444RMxc3wUakBz4zT74oNUpwoP69rdf2mmE=";
  };

  cargoHash = "sha256-BAUqH2RVpLLXvN43J67xqtrQZT3OgNA9ot+joOB70DY=";

  buildInputs = [ sqlite ];

  meta = {
    description = "CLI read-only interface for Mozilla Firefox's bookmarks";
    homepage = "https://github.com/zer0-x/foxmarks";
    changelog = "https://github.com/zer0-x/foxmarks/blobl/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
