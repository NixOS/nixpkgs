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
  version = "1.1.8-unstable-2026-04-30";

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy";
    rev = "df4cdae8e7fca04c0c65aef933bb28a01a346d77";
    hash = "sha256-FUs/0gqm0rlpThqaOTC1otFPoAnFyFhBrKHcbGefO9o=";
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
    hash = "sha256-STnqzVxClUfuf2la2R6yeIrNbaXsTpT6tX9xUJoLsK4=";
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
