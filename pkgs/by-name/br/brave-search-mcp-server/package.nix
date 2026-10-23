{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "brave-search-mcp-server";
  version = "2.1.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brave";
    repo = "brave-search-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K6BOxpPu1mJq4SzMos2Xy13mIlXDN05XAQiOYL22mf8=";
  };

  # Upstream's lockfile lacks `resolved` and `integrity` for 104 of its 184 packages, so npm
  # can't install them offline. This copy only adds those fields; every version is unchanged.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-/bYBoowEJB6nApQWk6xVjzATYBE8cMaPdovmP0sbAAE=";

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official MCP server for the Brave Search API";
    homepage = "https://github.com/brave/brave-search-mcp-server";
    changelog = "https://github.com/brave/brave-search-mcp-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "brave-search-mcp-server";
  };
})
