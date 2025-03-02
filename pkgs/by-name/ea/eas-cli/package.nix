{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  jq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eas-cli";
  version = "14.7.1";

  src = fetchFromGitHub {
    owner = "expo";
    repo = "eas-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h7LohShs4j9Z7Mbe6MSMqfszrEPBcGeTpB+ma3iBXyM=";
  };

  packageJson = finalAttrs.src + "/packages/eas-cli/package.json";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock"; # Point to the root lockfile
    hash = "sha256-pnp9MI2S5v4a7KftxYC3Sgc487vooX8+7lmYkmRTWWs=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    jq
  ];

  # Add version field to package.json to prevent yarn pack from failing
  preInstall = ''
    echo "Adding version field to package.json"
    jq '. + {version: "${finalAttrs.version}"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  postInstall = ''
    echo "Creating symlink for eas-cli binary"
    mkdir -p $out/bin
    ln -sf $out/lib/node_modules/eas-cli-root/packages/eas-cli/bin/run $out/bin/eas
    chmod +x $out/bin/eas
  '';

  meta = {
    changelog = "https://github.com/expo/eas-cli/releases/tag/v${finalAttrs.version}";
    description = "EAS command line tool from submodule";
    homepage = "https://github.com/expo/eas-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zestsystem ];
  };
})
