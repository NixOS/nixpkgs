{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "foxmarks";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = "foxmarks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6lJ9acVo444RMxc3wUakBz4zT74oNUpwoP69rdf2mmE=";
  };

  cargoHash = "sha256-BAUqH2RVpLLXvN43J67xqtrQZT3OgNA9ot+joOB70DY=";

  buildInputs = [ sqlite ];

  meta = {
    description = "CLI read-only interface for Mozilla Firefox's bookmarks";
    homepage = "https://github.com/zefr0x/foxmarks";
    changelog = "https://github.com/zefr0x/foxmarks/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
})
