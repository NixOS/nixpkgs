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
  pname = "prettier-plugin-php";
  packageName = "@prettier/plugin-php";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u7cBqZI67/QTBp8YpLOgtZUZt/aJxknjGyT4OSTVZNM=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Q8M4Mh0wQNmDkxtUr5bwyRiuFQTyGSGgkOVWhIien4s=";
  };

  yarnKeepDevDeps = true;

  # buildPhase = ''
  #   runHook preBuild
  #   yarn --offline build
  #   runHook postBuild
  # '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  meta = {
    description = "Prettier PHP Plugin";
    homepage = "https://github.com/prettier/prettier-php#readme";
    license = "MIT";
  };
})
