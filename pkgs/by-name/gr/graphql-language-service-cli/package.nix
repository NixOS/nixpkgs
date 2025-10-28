{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  versionCheckHook,
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

  patches = [
    ./patches/0001-repurpose-vscode-graphql-build-script.patch
  ];

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

    node esbuild.js --minify

    # copy package.json for --version command
    mv {out/graphql.js,package.json} $out/lib

    makeWrapper ${lib.getExe nodejs} $out/bin/graphql-lsp \
      --add-flags $out/lib/graphql.js \

    popd

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru = {
    updateScript = ./updater.sh;
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
