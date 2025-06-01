{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  stdenv,
  versionCheckHook,
  yarn-berry,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "prettier";
    tag = finalAttrs.version;
    hash = "sha256-jde5kU6wNJeNKtW2WlKaK9DkKOluiUy7KaonZVdwUxE=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-Yd1rHcPxKjGe8P1OuGrFjKgBnGTD+bSJP1iA0yHM6uM=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  installPhase = ''
    runHook preInstall

    yarn install --immutable
    yarn build --clean

    mkdir "$out"
    cp --recursive dist/* "$out"

    makeBinaryWrapper "${lib.getExe nodejs}" "$out/bin/prettier" \
      --add-flags "$out/bin/prettier.cjs"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/prettier/prettier/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Code formatter";
    homepage = "https://prettier.io/";
    license = lib.licenses.mit;
    mainProgram = "prettier";
    maintainers = with lib.maintainers; [ l0b0 ];
  };
})
