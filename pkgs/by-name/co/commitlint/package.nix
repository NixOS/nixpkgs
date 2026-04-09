{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  nodejs,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commitlint";
  version = "20.5.1";

  src = fetchFromGitHub {
    owner = "conventional-changelog";
    repo = "commitlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kOZym07WOcUszUxYWy10+08+wjsPQ8FdiJdyJOUXOgk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-oo0KWaDCQhZ7xWvKcfqi5QySb7Hq1C0CH037/8V60yU=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    makeBinaryWrapper
  ];

  postPatch = ''
    # Patch the CLI manifest to 20.5.1 so commitlint --version reports the correct version.
    # Keep this intentionally specific so the next update fails and can drop this patch.
    substituteInPlace @commitlint/cli/package.json \
      --replace-fail '"version": "20.5.0"' '"version": "20.5.1"'
  '';

  buildPhase = ''
    runHook preBuild

    # Remove test files to avoid dependency on commitlint test packages
    rm -rf @commitlint/**/*.test.{js,ts}

    # See https://github.com/conventional-changelog/commitlint/blob/20.1.0/Dockerfile.ci
    # Excludes `config-nx-scopes` which is a plain JavaScript package
    pkgs=(
      "config-validator"
      "rules"
      "parse"
      "is-ignored"
      "lint"
      "resolve-extends"
      "execute-rule"
      "load"
      "read"
      "types"
      "cli"
      "config-conventional"
      "config-pnpm-scopes"
      "ensure"
      "format"
      "message"
      "to-lines"
      "top-level"
    )
    for p in "''${pkgs[@]}" ; do
      echo "Building package: @commitlint/$p"
      cd @commitlint/$p/
      yarn run --offline tsc --build --force
      cd ../..
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn install --offline --production --ignore-scripts
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
    maintainers = [ ];
  };
})
