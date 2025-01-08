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
stdenvNoCC.mkDerivation rec {
  pname = "eas-cli";
  version = "14.3.0";

  src = fetchFromGitHub {
    owner = "expo";
    repo = "eas-cli";
    rev = "v${version}";
    hash = "sha256-a7ZSogvO8yETwjJnXL5i+xXSZPRAMWpLJKZV6EZi9Tw=";
  };

  packageJson = src + "/packages/eas-cli/package.json";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock"; # Point to the root lockfile
    hash = "sha256-XnWH1RwwFMLt2KaSSnQim5bog+uf0o4HhVDRjfGpgdQ=";
  };

  nativeBuildInputs = [yarnConfigHook yarnBuildHook yarnInstallHook nodejs jq];

  # Add version field to package.json to prevent yarn pack from failing
  preInstall = ''
    echo "Adding version field to package.json"
    jq '. + {version: "${version}"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  postInstall = ''
    echo "Creating symlink for eas-cli binary"
    mkdir -p $out/bin
    ln -sf $out/lib/node_modules/eas-cli-root/packages/eas-cli/bin/run $out/bin/eas
    chmod +x $out/bin/eas
  '';

  meta = {
    description = "EAS command line tool from submodule";
    homepage = "https://github.com/expo/eas-cli/tree/main/packages/eas-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [zestsystem];
  };
}

