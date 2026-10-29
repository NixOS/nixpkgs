{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "open-websearch";
  version = "2.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Aas-ee";
    repo = "open-webSearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Hf1e3AgSC0brQqMqAbTt718ly1Ms5GoV0JuDAE1BCc=";
  };

  npmDepsHash = "sha256-fcRKZroEokDjEY1xiIu5kOqthIK0zx6ZnjpWMkzyIj0=";

  meta = {
    description = "Web search MCP server";
    homepage = "https://github.com/Aas-ee/open-webSearch";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ReStranger ];
    mainProgram = "open-websearch";
  };
})
