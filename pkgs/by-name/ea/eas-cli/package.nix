{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  jq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eas-cli";
  version = "16.28.0";

  src = fetchFromGitHub {
    owner = "expo";
    repo = "eas-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/1E26CDD+vXR6/v9zOFOcJEuU/evUSVovQwnuyoV4SA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock"; # Point to the root lockfile
    hash = "sha256-W2FuU4J28/qtXUa+eqirpc7bjRdL1fk6mgGxR50icYI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    jq
  ];

  postPatch = ''
    # Disable Nx integration in Lerna to avoid the native pseudo terminal panic in the sandbox.
    tmpfile="$(mktemp)"
    jq '.useNx = false' lerna.json > "$tmpfile"
    mv "$tmpfile" lerna.json
  '';

  # yarnInstallHook strips out build outputs within packages/eas-cli resulting in most commands missing from eas-cli.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/eas-cli-root
    cp -r . $out/lib/node_modules/eas-cli-root

    runHook postInstall
  '';

  # postFixup is used to override the symlink created in the fixupPhase
  postFixup = ''
    mkdir -p $out/bin
    ln -sf $out/lib/node_modules/eas-cli-root/packages/eas-cli/bin/run $out/bin/eas
  '';

  meta = {
    changelog = "https://github.com/expo/eas-cli/releases/tag/v${finalAttrs.version}";
    description = "EAS command line tool from submodule";
    homepage = "https://github.com/expo/eas-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zestsystem ];
  };
})
