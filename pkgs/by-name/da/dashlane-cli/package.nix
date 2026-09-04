{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs_22,
  python3,
  makeWrapper,
  versionCheckHook,
}:

let
  yarn-berry = yarn-berry_4.override { nodejs = nodejs_22; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dashlane-cli";
  version = "6.2636.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dashlane";
    repo = "dashlane-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v21xsVuHmSCWWbDnUJHV5QWd6wrLAv6r/nQ5ka3Zx8o=";
  };

  missingHashes = ./missing-hashes.json;

  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-K+PaoodH8JAH5kGk2tMxxLShukg1jDC3Tw6tqLI+6Yw=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
    python3
    yarn-berry
    (yarn-berry.yarnBerryConfigHook.override { nodejs = nodejs_22; })
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  env = {
    COMMIT_HASH = finalAttrs.src.rev;
    YARN_LOCKFILE_VERSION_OVERRIDE = "8";
  };

  postPatch = ''
    printf "approvedGitRepositories:\n  - '**'\nenableScripts: true\n" >> .yarnrc.yml
  '';

  buildPhase = ''
    runHook preBuild

    YARN_IGNORE_PATH=1 yarn build

    # Upstream's build generates a manifest containing only the dependencies
    # that esbuild leaves external.
    mv package.json package.json.build
    cp dist/package.json package.json
    YARN_IGNORE_PATH=1 yarn install
    mv package.json.build package.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dashlane-cli
    cp -r dist node_modules $out/lib/dashlane-cli
    makeWrapper ${lib.getExe nodejs_22} $out/bin/dcli \
      --add-flags $out/lib/dashlane-cli/dist/index.cjs

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  installCheckPhase = ''
    runHook preInstallCheck

    ${lib.getExe nodejs_22} -e "
      const Database = require('$out/lib/dashlane-cli/node_modules/better-sqlite3');
      const db = new Database(':memory:');
      db.prepare('select 1').get();
      db.close();
    "

    runHook postInstallCheck
  '';

  meta = {
    description = "Command-line interface for the Dashlane password manager";
    homepage = "https://dashlane.github.io/dashlane-cli/";
    changelog = "https://github.com/Dashlane/dashlane-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "dcli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
