{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  gitUpdater,
  graphql-language-service-cli,
  makeWrapper,
  nodejs,
  stdenv,
  testers,
  yarnBuildHook,
  yarnConfigHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphql-language-service-cli";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "graphql";
    repo = "graphiql";
    tag = "graphql-language-service-cli@${finalAttrs.version}";
    hash = "sha256-NJTggaMNMjOP5oN+gHxFTwEdNipPNzTFfA6f975HDgM=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-ae6KP2sFgw8/8YaTJSPscBlVQ5/bzbvHRZygcMgFAlU=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    pushd packages/graphql-language-service-cli

    # even with dev dependencies stripped, node_modules is over 1GB
    # just bundle what we need
    cp ${./esbuild.js} esbuild.js
    node esbuild.js

    # copy package.json for --version command
    mv {out/graphql.js,package.json} $out/lib

    makeWrapper ${nodejs}/bin/node $out/bin/graphql-lsp \
      --add-flags $out/lib/graphql.js \

    popd

    runHook postInstall
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "graphql-language-service-cli@";
    };

    tests.version = testers.testVersion {
      package = graphql-language-service-cli;
    };
  };

  meta = {
    description = "Official, runtime independent Language Service for GraphQL";
    homepage = "https://github.com/graphql/graphiql";
    changelog = "https://github.com/graphql/graphiql/blob/${finalAttrs.src.tag}/packages/graphql-language-service-cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanregner ];
    mainProgram = "graphql-lsp";
  };
})
