{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchNpmDeps,
  nodejs,
  writableTmpDirAsHomeHook,
  pnpmConfigHook,
  pnpm,
  unzip,
  patchelf,
  autoPatchelfHook,
  ripgrep,
  versionCheckHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kilocode-cli";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "Kilo-Org";
    repo = "kilocode";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-XlJ9/9FABLpKVJXdIRzbzOpJVXdIzgFvPPeER1LRsuk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-Q/LamZwVaIQVILtXRi1RQrYtpxYJWEKPAt3knwm47S0=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/cli";
    postPatch = ''
      cp ./npm-shrinkwrap.dist.json ./npm-shrinkwrap.json
    '';
    hash = "sha256-wH4Gyd5nv8sCSQStFqIidoICvlXXEs2xNNX+DH133wA=";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    pnpmConfigHook
    pnpm
    nodejs
    unzip
    patchelf
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  strictDeps = true;

  env.npm_config_manage_package_manager_versions = "false";

  buildPhase = ''
    runHook preBuild

    mkdir -p ./cli/.dist/
    find ./cli -maxdepth 1 -type f -name "*.dist.*" -print0 | while IFS= read -r -d "" file; do
      cp "$file" "./cli/.dist/$(basename "$file" | sed 's/\.dist\././')"
    done

    if ! diff "$PWD/cli/npm-shrinkwrap.dist.json" "$npmDeps/package-lock.json"; then
      echo "npm-shrinkwrap.json is out of date"
      echo "The npm-shrinkwrap.json in src is not the same as the in $npmDeps."
      echo "To fix the issue:"
      echo '1. Use `lib.fakeHash` as the npmDepsHash value'
      echo "2. Build the derivation and wait for it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256-' value back into the npmDepsHash field"
      exit 1
    fi
    export npm_config_cache="$npmDeps"
    export npm_config_offline="true"
    export npm_config_progress="false"
    (
      cd ./cli/.dist
      npm ci --omit=dev --ignore-scripts
      patchShebangs node_modules
      if [ -d node_modules/@vscode/ripgrep ]; then
        mkdir -p node_modules/@vscode/ripgrep/bin
        ln -s ${lib.getExe ripgrep} node_modules/@vscode/ripgrep/bin/rg
      fi
      npm rebuild
    )
    substituteInPlace cli/package.json \
      --replace-fail 'npm install --omit=dev --prefix ./dist' 'mv ./.dist/node_modules ./dist/node_modules'

    node --run cli:bundle
    touch ./cli/dist/.env

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/lib/node_modules/@kilocode/
    mv ./cli/dist $out/lib/node_modules/@kilocode/cli
    ln -s $out/lib/node_modules/@kilocode/cli/index.js $out/bin/kilocode
    chmod +x $out/bin/kilocode

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=^cli-v(.+)$" ]; };
  };

  meta = {
    description = "Terminal User Interface for Kilo Code";
    homepage = "https://kilocode.ai/cli";
    downloadPage = "https://www.npmjs.com/package/@kilocode/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "kilocode";
  };
})
