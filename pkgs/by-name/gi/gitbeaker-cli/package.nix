{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  gnutar,
  gnused,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gitbeaker-cli";
  version = "44.0.2";

  src = fetchFromGitHub {
    owner = "jdalrymple";
    repo = "gitbeaker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S3YtbE+3dy0dlmgYGj8cxpb2SD1XGefp9EPN/wyg1FY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-NaGJkvN+ZcVhTXql6gEFm3ISTDLh5vIAf5b7tUFKZFU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    gnutar
    gnused
  ];

  buildPhase = ''
    runHook preBuild

    # Needed in macOS sandbox (See https://github.com/pnpm/pnpm/pull/17757)
    # Remove after pnpm is updated to 12.19 or later
    find . -path "*/node_modules/.bin/*" -type f | while IFS= read -r file; do
      substituteInPlace "$file" \
        --replace-quiet \
          'if command -p -v "$1" >/dev/null 2>&1 || ! command -v "$1" >/dev/null 2>&1; then command -p "$@"; else command "$@"; fi' \
          'if [ -x "/usr/bin/$1" ] || [ -x "/bin/$1" ] || ! command -v "$1" >/dev/null 2>&1; then command -p "$@"; else command "$@"; fi'
    done

    pnpm --filter "@gitbeaker/*..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # `pnpm prune` doesn't support monorepos, and with pnpm 12 it also tries
    # to verify the lockfile against supply-chain policies over the network.
    # Reinstall production dependencies only instead, as `pnpm prune --help`
    # recommends for monorepos.
    find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
    pnpm install \
      --offline \
      --ignore-scripts \
      --frozen-lockfile \
      --prod

    # Remove non-deterministic files
    rm node_modules/{.modules.yaml,.pnpm-workspace-state-v1.json}

    mkdir -p $out/bin
    mkdir -p $out/lib
    mv packages $out/lib/packages
    mv node_modules/ $out/lib/node_modules

    DIST="$out/lib/packages/cli/dist/index.mjs"
    patchShebangs $DIST
    ln -s $DIST $out/bin/gb
    ln -s $DIST $out/bin/gitbeaker

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jdalrymple/gitbeaker/releases/tag/${finalAttrs.version}";
    description = "CLI Wrapper for the @gitbeaker/rest SDK";
    homepage = "https://github.com/jdalrymple/gitbeaker";
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    mainProgram = "gitbeaker";
    license = lib.licenses.mit;
  };
})
