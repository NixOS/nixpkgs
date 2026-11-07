{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commitlint";
  version = "21.2.4";

  src = fetchFromGitHub {
    owner = "conventional-changelog";
    repo = "commitlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NU8X/VGBnMuJjhevdqX7HCv0lmBkUzXQpESqSJ28eyg=";
  };

  pnpmWorkspaces = [
    "."
    "@commitlint/cli..."
    "@commitlint/config-conventional..."
    "@commitlint/config-pnpm-scopes..."
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
    hash = "sha256-L8lcAQYcLPQ8GvOnsZQIHj9udBWd6iABeud9MqUGiFA=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_12
    nodejs
    makeBinaryWrapper
  ];

  # Make pnpm happy to re-install deps for prod
  env.CI = true;

  buildPhase = ''
    runHook preBuild

    # Tests of this package are not excluded by its tsconfig and need test-only workspace packages
    rm @commitlint/config-pnpm-scopes/index.test.ts

    for p in cli config-conventional config-pnpm-scopes; do
      echo "Building package: @commitlint/$p"
      pushd @commitlint/$p
      ../../node_modules/.bin/tsc --build --force
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules @commitlint/*/node_modules @packages/*/node_modules
    export pnpm_config_node_linker=hoisted
    export pnpm_config_prefer_symlinked_executables=false
    pnpm --filter="@commitlint/cli..." --filter="@commitlint/config-conventional..." --filter="@commitlint/config-pnpm-scopes..." --offline --prod --ignore-scripts install

    mkdir -p $out/bin
    mkdir -p $out/lib/node_modules/@commitlint/root
    mv * $out/lib/node_modules/@commitlint/root/

    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/commitlint \
      --add-flags "$out/lib/node_modules/@commitlint/root/@commitlint/cli/cli.js" \
      --set NODE_PATH "$out/lib/node_modules/@commitlint/root/node_modules"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/conventional-changelog/commitlint/releases/tag/${finalAttrs.src.tag}";
    description = "Lint your commit messages";
    homepage = "https://commitlint.js.org/";
    license = lib.licenses.mit;
    mainProgram = "commitlint";
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
