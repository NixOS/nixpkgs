{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeWrapper,
  nix-update-script,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
  stdenv,
  versionCheckHook,
}:
let
  nodejs = nodejs_24;
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mongodb-mcp-server";
  version = "1.14.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongodb-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n/KY3Od+IgqIY1/RgZNf7T2vWTZxnQZbT1N80Qu3BiQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-svT6N2+fe3yDFPzV9ih1Iz6vdgXQSIb06dLZj2FKOH4=";
  };

  dontStrip = true;

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # The prepare script (husky && pnpm run build) doesn't do anything useful in this context
    # since husky just installs git hooks, the package is already built, and it causes an error
    pnpm pkg delete scripts.prepare

    # --config.inject-workspace-packages=true: enables workspace option required by deploy since pnpm 10
    pnpm --filter ${finalAttrs.pname} \
         --offline \
         --prod \
         --config.inject-workspace-packages=true \
         deploy $out/lib/mongodb-mcp-server

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/mongodb-mcp-server \
      --add-flags "$out/lib/mongodb-mcp-server/dist/esm/index.js"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Model Context Protocol server to connect to MongoDB databases and MongoDB Atlas clusters";
    homepage = "https://github.com/mongodb-js/mongodb-mcp-server";
    changelog = "https://github.com/mongodb-js/mongodb-mcp-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ clay53 ];
    mainProgram = "mongodb-mcp-server";
    platforms = nodejs.meta.platforms;
  };
})
