{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "happy-coder";
  version = "0-unstable-2026-02-14";

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy";
    rev = "bb7a1173c39f6db07963d4a3adc38be5ea2493fd";
    hash = "sha256-RL1ZEkYOAkA/gRGAtOBRMySacFlla+Tu5APHE9UjVps=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-wE3W7o/zBRLNv/+wxRAQ+c3lkEi6biA7yqnrpFBVoBY=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    makeWrapper
  ];

  # Fix type error in src/agent/acp/runAcp.ts where mode.description
  # is `string | null | undefined` but the function expects `string | undefined`
  postPatch = ''
    substituteInPlace packages/happy-cli/src/agent/acp/runAcp.ts \
      --replace-fail 'formatOptionalDetail(mode.description,' \
                     'formatOptionalDetail(mode.description ?? undefined,'
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline workspace @slopus/happy-wire build
    yarn --offline workspace happy-coder build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local packageOut="$out/lib/node_modules/happy-coder"
    mkdir -p "$packageOut"
    mkdir -p "$out/bin"

    # Copy the built CLI package
    cp -r packages/happy-cli/dist "$packageOut/dist"
    cp -r packages/happy-cli/bin "$packageOut/bin"
    cp packages/happy-cli/package.json "$packageOut/package.json"

    # Copy hoisted node_modules, removing workspace symlinks that would dangle
    cp -r node_modules "$packageOut/node_modules"
    for link in "$packageOut"/node_modules/{happy-coder,happy-app,happy-server,@slopus/agent,@slopus/happy-wire}; do
      rm -rf "$link"
    done

    # Copy nohoisted dependencies from the CLI workspace
    if [ -d packages/happy-cli/node_modules ]; then
      cp -rn packages/happy-cli/node_modules/. "$packageOut/node_modules/"
    fi

    # Install the built workspace dependency
    rm -rf "$packageOut/node_modules/@slopus/happy-wire"
    mkdir -p "$packageOut/node_modules/@slopus/happy-wire"
    cp -r packages/happy-wire/dist "$packageOut/node_modules/@slopus/happy-wire/dist"
    cp packages/happy-wire/package.json "$packageOut/node_modules/@slopus/happy-wire/package.json"

    # Remove all dangling symlinks (workspace artifacts)
    find "$packageOut/node_modules" -xtype l -delete

    # Create wrapper scripts
    for bin in happy happy-mcp; do
      makeWrapper ${nodejs}/bin/node "$out/bin/$bin" \
        --add-flags "$packageOut/bin/$bin.mjs"
    done

    runHook postInstall
  '';

  meta = {
    description = "Mobile and web client wrapper for Claude Code and Codex with end-to-end encryption";
    homepage = "https://github.com/slopus/happy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onsails ];
    mainProgram = "happy";
  };
})
