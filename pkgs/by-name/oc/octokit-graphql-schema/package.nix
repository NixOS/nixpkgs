{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "octokit-graphql-schema";
  version = "15.26.1";

  src = fetchFromGitHub {
    owner = "octokit";
    repo = "graphql-schema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3T5Rv7N+0lPqsRomSaf+GphP1A6Ft+Lu8gOYvZGxaD8=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 schema.graphql schema.json -t "$out/share/octokit-graphql-schema"

    runHook postInstall
  '';

  passthru = {
    graphql = "${finalAttrs.finalPackage}/share/octokit-graphql-schema/schema.graphql";
    json = "${finalAttrs.finalPackage}/share/octokit-graphql-schema/schema.json";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GitHub’s GraphQL Schema";
    longDescription = ''
      GitHub's public GraphQL schema, ready for consumption by other packages,
      obtained from the source of the `@octokit/graphql-schema` npm package.
    '';
    homepage = "https://github.com/octokit/graphql-schema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mightyiam ];
    platforms = lib.platforms.all;
  };
})
