{
  lib,
  stdenv,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cspell";
  version = "9.7.0";

  src = fetchFromGitHub {
    owner = "streetsidesoftware";
    repo = "cspell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WT2MlBtFazi7vC7+2Dx1Y0Z5B3j0tFT6jUajyqhxlDw=";
  };

  pnpmWorkspaces = [ "cspell..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-EKnczZ/7O2ZMaSlIFfLk9WXyf/ubynhmecs+IyIoTHw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildInputs = [
    nodejs
    gitMinimal
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "cspell..." build

    runHook postBuild
  '';

  # Make PNPM happy to re-install deps for prod
  env.CI = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/cspell
    mkdir $out/bin

    # Re-install only production dependencies
    rm -rf node_modules packages/*/node_modules scripts/node_modules
    pnpm config set nodeLinker hoisted
    pnpm config set preferSymlinkedExecutables false
    pnpm --filter="cspell..." --offline --prod install

    mv ./package.json ./packages ./bin.mjs ./node_modules $out/lib/node_modules/cspell
    # Clean up unneeded files
    pushd $out/lib/node_modules/cspell/packages
    rm -rf */*.md */tsconfig.* */LICENSE Samples */**/*.test.{j,t}s */**/*.map */__snapshots__ */src */Samples
    # These are example dictionaries, and are not needed
    rm -rf hunspell-reader/dictionaries
    pushd cspell
    rm -rf dist/tsc
    rm -rf samples/ fixtures/ tools/ static/
    popd
    popd

    ln -s $out/lib/node_modules/cspell/bin.mjs $out/bin/cspell

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spell checker for code";
    homepage = "https://cspell.org";
    changelog = "https://github.com/streetsidesoftware/cspell/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cspell";
    maintainers = [ lib.maintainers.pyrox0 ];
  };
})
