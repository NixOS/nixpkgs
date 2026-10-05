{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "commitlint";
  version = "21.2.3";

  src = fetchFromGitHub {
    owner = "conventional-changelog";
    repo = "commitlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FrpD6e2jgu2HmrtViKUCMV7RrXVNEkSJbW0UTIUbhgE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-rD+oU5OmhzP7yzGEOaHNd4bDR7CjqRyzBxui79+6YmE=";
  };

  buildPhase = ''
    runHook preBuild

    # Remove test files to avoid dependency on commitlint test packages
    find @commitlint -type f \( -name '*.test.js' -o -name '*.test.ts' \) -delete

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    find . -name node_modules -type d -prune -exec rm -rf {} +
    pnpm install --offline --ignore-scripts --frozen-lockfile --prod

    # TODO: when nixpkgs pnpm_12 >= 12.5.1, use pnpm_12 and remove this line https://github.com/pnpm/pnpm/issues/3645#issuecomment-5743392718
    find . -path '*/node_modules/*' -xtype l -delete
    # remove non-deterministic files
    rm -f node_modules/{.modules.yaml,.pnpm-workspace-state-v1.json}

    # link workspace packages into the root so NODE_PATH can resolve bundled configs
    mkdir -p node_modules/@commitlint
    for pkg in @commitlint/*; do
      ln -s "../../$pkg" "node_modules/$pkg"
    done
    for pkg in @alias/*; do
      ln -s "../$pkg" "node_modules/$(basename "$pkg")"
    done

    mkdir -p $out/{bin,lib/node_modules/@commitlint/root}
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

  installCheckPhase = ''
    runHook preInstallCheck

    # check bundled configs resolve, both scoped and via the unscoped alias (commitlint-config-angular)
    echo 'feat: add x' | $out/bin/commitlint --extends @commitlint/config-conventional
    echo 'feat: add x' | $out/bin/commitlint --extends angular

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/conventional-changelog/commitlint/releases/tag/${finalAttrs.src.tag}";
    description = "Lint your commit messages";
    homepage = "https://commitlint.js.org/";
    license = lib.licenses.mit;
    mainProgram = "commitlint";
    maintainers = [ ];
  };
})
