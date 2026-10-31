{
  lib,
  stdenv,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cspell";
  version = "10.4.0";

  src = fetchFromGitHub {
    owner = "streetsidesoftware";
    repo = "cspell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YrX0LPepN+nO/abqMFQpN9uuBnwrL5/ne/AznExi7yI=";
  };

  pnpmWorkspaces = [
    "cspell..."
    "@internal/scripts"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-R2PlFAZPnt0L2Zvpbp8UTjqigbGHm+rvY5w6yTGZ9Qk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_12
  ];

  buildInputs = [
    nodejs
    gitMinimal
  ];

  buildPhase = ''
    runHook preBuild

    # Build the internal tsdown config first, upstream does it in a postinstall script
    pnpm --filter "@internal/tsdown" build
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
    export pnpm_config_node_linker=hoisted
    export pnpm_config_prefer_symlinked_executables=false
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
    maintainers = [ ];
  };
})
