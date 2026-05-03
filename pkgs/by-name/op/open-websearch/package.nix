{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "open-websearch";
  version = "1.2.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Aas-ee";
    repo = "open-webSearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ko216HwLEFhVOsyOBTDZNK0MfXL55OFrIM7RR1BRJJM=";
  };

  npmDepsHash = "sha256-yhWFDXEPvm7HWFOiO3X1YRFYpAT0QeZJuFt65yxu+E0=";

  meta = {
    description = "Web search MCP server";
    homepage = "https://github.com/Aas-ee/open-webSearch";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ReStranger ];
    mainProgram = "open-websearch";
  };
})
