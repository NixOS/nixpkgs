{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commitlint";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "conventional-changelog";
    repo = "commitlint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o8AnIewSmg8vRjs8LU6QwRyl2hMQ2iK5W7WL137treU=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Kg19sEgstrWj+JLzdZFnMeb0F5lFX3Z0VPNyiYPi6nY=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    pkgs=("config-validator" "rules" "parse" "is-ignored" "lint"
          "resolve-extends" "execute-rule" "load" "read" "types" "cli")
    for p in "''${pkgs[@]}" ; do
      cd @commitlint/$p/
      yarn run tsc --build --force
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
    ln -s $out/lib/node_modules/@commitlint/root/@commitlint/cli/cli.js $out/bin/commitlint

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/conventional-changelog/commitlint/releases/tag/v${finalAttrs.version}";
    description = "Lint your commit messages";
    homepage = "https://commitlint.js.org/";
    license = lib.licenses.mit;
    mainProgram = "commitlint";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
