{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  versionCheckHook,

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
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "${tag-prefix}@${finalAttrs.version}";
    hash = "sha256-u0sFNX19ZBWvA7HYWdM4iI9AvEVz/CK6dLfZ80Rxa9c=";
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
    hash = "sha256-8RRHfCTZVC91T1Qx+ACCo2oG4ZwMNy5WYakCjmBhe3Q=";
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "${tag-prefix}@(.*)"
    ];
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
