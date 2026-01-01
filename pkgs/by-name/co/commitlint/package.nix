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
<<<<<<< HEAD
  version = "20.2.0";
=======
  version = "20.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "conventional-changelog";
    repo = "commitlint";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-L9HfuwpFmKWoEyFdo7+UIEeEcD0jFhunj0x6UFHfhEY=";
=======
    hash = "sha256-o8AnIewSmg8vRjs8LU6QwRyl2hMQ2iK5W7WL137treU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
<<<<<<< HEAD
    hash = "sha256-rKVMSbsipd8J2E+E2RdeXYDsMwSzFZMJJ4zceOLBbCs=";
=======
    hash = "sha256-Kg19sEgstrWj+JLzdZFnMeb0F5lFX3Z0VPNyiYPi6nY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    makeBinaryWrapper
  ];

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
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
