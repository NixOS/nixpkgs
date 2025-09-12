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
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "prettier";
    tag = finalAttrs.version;
    hash = "sha256-uMLRFBZP7/42R6nReONcb9/kVGCn3yGHLcLFajMZLmQ=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-dpxzbtWyXsHS6tH6DJ9OqSsUSc+YqYeAPJYb95Qy5wQ=";
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

    cp --recursive dist/prettier "$out"

    makeBinaryWrapper "${lib.getExe nodejs}" "$out/bin/prettier" \
      --add-flags "$out/bin/prettier.cjs"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
