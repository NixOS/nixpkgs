{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "happy-coder";
  version = "1.1.6-unstable-2026-04-17";

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy";
    rev = "c8c389f7e6ded2d02e65775884aeea53408fee97";
    hash = "sha256-YoXslJyNvg5ZNnYWmwyJWWIz0q84+au8UNaZ/K69pFY=";
  };

  pnpmWorkspaces = [ "happy..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-sWRISfCsWQslNhucMiRhIf8ncU4OFaOYOrcc/1ATI98=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
    makeBinaryWrapper
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    pnpm --filter happy... build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local packageOut="$out/lib/node_modules/happy-coder"
    mkdir -p "$packageOut/node_modules/@slopus/happy-wire"
    mkdir -p "$out/bin"

    # Reinstall the filtered workspace in production mode so the copied
    # runtime tree only contains dependencies needed by the CLI package.
    rm -rf node_modules packages/happy-cli/node_modules packages/happy-wire/node_modules
    pnpm install --offline --prod --ignore-scripts --frozen-lockfile --filter happy...

    cp -r packages/happy-cli/dist "$packageOut/dist"
    cp -r packages/happy-cli/bin "$packageOut/bin"
    cp -r packages/happy-cli/scripts "$packageOut/scripts"
    cp -r packages/happy-cli/tools "$packageOut/tools"
    cp packages/happy-cli/package.json "$packageOut/package.json"

    cp -r node_modules/. "$packageOut/node_modules/"

    cp -r packages/happy-wire/dist "$packageOut/node_modules/@slopus/happy-wire/dist"
    cp packages/happy-wire/package.json "$packageOut/node_modules/@slopus/happy-wire/package.json"
    if [ -f packages/happy-wire/README.md ]; then
      cp packages/happy-wire/README.md "$packageOut/node_modules/@slopus/happy-wire/README.md"
    fi

    patchShebangs "$packageOut/bin" "$packageOut/scripts"
    node "$packageOut/scripts/unpack-tools.cjs"

    makeBinaryWrapper ${lib.getExe nodejs} "$out/bin/happy" \
      --add-flags "--no-warnings" \
      --add-flags "--no-deprecation" \
      --add-flags "$packageOut/bin/happy.mjs"

    makeBinaryWrapper ${lib.getExe nodejs} "$out/bin/happy-mcp" \
      --add-flags "--no-warnings" \
      --add-flags "--no-deprecation" \
      --add-flags "$packageOut/bin/happy-mcp.mjs"

    runHook postInstall
  '';

  meta = {
    description = "Mobile and web client for Claude Code and Codex";
    homepage = "https://happy.engineering";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onsails ];
    mainProgram = "happy";
  };
})
