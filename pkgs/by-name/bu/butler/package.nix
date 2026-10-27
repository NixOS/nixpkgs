{
  buildGoModule,
  brotli,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "butler";
  version = "15.32.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XODUoDjntEjc/sy92BirIDAJ4GmxzdDvD+laRDDd4CA=";
  };

  buildInputs = [ brotli ];

  doCheck = false; # disabled because the tests don't work in a non-FHS compliant environment.

  vendorHash = "sha256-IJ/ODqn7dMwW/PZ7dmad/BdlhsR0FslSuGr6qJLQCSA=";

  meta = {
    description = "Command-line itch.io helper";
    changelog = "https://github.com/itchio/butler/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "http://itch.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naelstrof ];
  };
})
