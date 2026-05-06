/**
  ## Notes

  Git Tag 3.4.2 was unpublished, nuking changes that made it compatible with
  NodeJS, so `rev` is currently used, check following links for details;

  - https://github.com/prettier/plugin-xml/blob/main/CHANGELOG.md
  - https://github.com/prettier/plugin-xml/commit/e8481dceaf50a4c4c6be853c4cd80d4b604d1465

  The `package.json` defines a "script.prepare" that Yarn implicitly executes
  which also requires husky for development, this is disabled explicitly in
  `buildPhase` here as it is unnecessary.
*/
{
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-xml";
  packageName = "@prettier/plugin-xml";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-xml";
    # tag = "v${finalAttrs.version}";
    rev = "cc686f6c8b9dab4ffef8c5da41a7fe8faba013e3";
    hash = "sha256-N65TxaOa/uGGQutGcVDttUBc/bA1tF0UNuiY/kOkK1o=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-jryulyIx+pMVVOLkeDcWVMJGIT67kIQEnHAloPImQRU=";
  };

  yarnKeepDevDeps = true;

  buildPhase = ''
    runHook preBuild

    yarn --ignore-scripts --offline install
    node ./bin/languages.js

    runHook postBuild
  '';

  installPhase = ''
    mkdir $out

    cp -r ./package.json ./bin ./src ./node_modules $out/
  '';

  nativeBuildInputs = [
    nodejs
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  meta = {
    description = "Prettier XML Plugin";
    homepage = "https://github.com/prettier/prettier-xml#readme";
    license = "MIT";
  };
})
