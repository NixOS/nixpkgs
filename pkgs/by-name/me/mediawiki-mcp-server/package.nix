{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mediawiki-mcp-server";
  version = "0.19.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ProfessionalWiki";
    repo = "MediaWiki-MCP-Server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TZ4SwtZ69Eg4tRpWjaeRx7bBFeO94SOYvWFGllVxxOE=";
  };

  # Drop the `prepare` lifecycle script: npm runs it automatically after
  # `npm install` and it usually triggers a build/bundle step that
  # reaches for paths outside the Nix store.
  preBuild = ''
    ${jq}/bin/jq 'del(.scripts.prepare)' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-LjIF3VuENLf0kRvH9lrEyG/JLMkk0WnSqpXMEZxcM8c=";

  npmBuildScript = "build";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Model Context Protocol server for MediaWiki";
    homepage = "https://github.com/ProfessionalWiki/MediaWiki-MCP-Server";
    changelog = "https://github.com/ProfessionalWiki/MediaWiki-MCP-Server/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "mediawiki-mcp-server";
  };
})
