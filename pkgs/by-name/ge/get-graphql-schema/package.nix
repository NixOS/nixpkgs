{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  npmHooks,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "get-graphql-schema";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "prisma-labs";
    repo = "get-graphql-schema";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ujc0LGAqmo4SmItm4VcbBOtmUvL6aV1ppMm4fMmuSRs=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-TZGNX8UHbolLyBmQNGTnFjgx3/3f2HNVQf/h9rIVJKs=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    npmHooks.npmInstallHook
    nodejs
  ];

  meta = {
    description = "Fetch and print the GraphQL schema from a GraphQL HTTP endpoint.";
    homepage = "https://github.com/prisma-labs/get-graphql-schema";
    license = lib.licenses.mit;
    mainProgram = "get-graphql-schema";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
