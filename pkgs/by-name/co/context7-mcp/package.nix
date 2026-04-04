{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,

  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
let
  tag-prefix = "@upstash/context7-mcp";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "context7-mcp";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "${tag-prefix}@${finalAttrs.version}";
    hash = "sha256-bQXmKY4I5k5uaQ2FVEOPkym5X3mR87nALf3+jqJjJjE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-EjEdbPKXJbxaDBuAg/j+BSjI/W3HdsqbtDky0TPUB88=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter ${tag-prefix} build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm --filter ${tag-prefix} \
         --offline \
         --config.inject-workspace-packages=true \
         deploy $out/lib/context7

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/context7-mcp \
      --add-flags "$out/lib/context7/dist/index.js"

    cp -r $src/skills $out

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo "Executing custom version check for MCP stdio server..."

    output=$(< /dev/null $out/bin/context7-mcp 2>&1 || true)

    if echo "$output" | grep -Fq "v${finalAttrs.version}"; then
      echo "versionCheckPhase: found version v${finalAttrs.version}"
    else
      echo "versionCheckPhase: failed to find version v${finalAttrs.version}"
      echo "Output was:"
      echo "$output"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex '${tag-prefix}@(.*)'" ];
  };

  meta = {
    description = "MCP Server for up-to-date code documentation for LLMs and AI code editors";
    homepage = "https://context7.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arunoruto ];
    mainProgram = "context7-mcp";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
