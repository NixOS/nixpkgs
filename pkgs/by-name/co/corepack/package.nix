{
  lib,
  stdenvNoCC,
  cacert,
  yarn-berry,
  nodejs,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  fetchpatch2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "corepack";
  version = "0.34.4";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "corepack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AE2tDeDs1wzDdTrkG/ic2ydQC8G2wcaKD6s7ec7p+Ew=";
  };

  patches = [
    # The build fails with better-sqlite3, needed for installCheck phase.
    # We can use the built-in SQLite module instead (and skip the installCheck phase on version of
    # Node.js that do not have built-in SQLite support).
    ./use-builtin-sqlite.patch
  ];

  nativeBuildInputs = [
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];
  buildInputs = [
    nodejs
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit nodejs;
    inherit (finalAttrs)
      missingHashes
      patches
      src
      ;
    hash = "sha256-Yzm3PtdbR9Tx2bisdzTw0XGD6rAc/KUCzmhjGuXdft4=";
  };

  postPatch = ''
    substituteInPlace tests/_runCli.ts --replace-fail 'require.resolve(`../dist/corepack.js`)' "'$out/bin/corepack'"
    substituteInPlace tests/main.test.ts --replace-fail 'npath.dirname(__dirname)' "'$out'"

    substituteInPlace mkshims.ts --replace-fail './lib/corepack.cjs' '../lib/corepack.cjs'
    substituteInPlace \
      sources/corepackUtils.ts \
      sources/commands/Enable.ts \
      --replace-fail 'require.resolve(`corepack/package.json`)' "'$out/package.json'"
  '';

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/lib/corepack.cjs -t $out/lib
    node -p 'Object.keys(require("./package.json").publishConfig.bin).join("\0")' | while IFS= read -r -d "" binName; do
      echo "Installing bin/$binName"
      install -Dm755 "dist/$binName.js" -T "$out/bin/$binName"
    done
    mkdir "$out/dist"
    find dist -maxdepth 1 -name "*.js" -print0 | while IFS= read -r -d "" jsFile; do
      echo "Installing $jsFile"
      if [ -f "$out/bin/''${jsFile:5:-3}" ]; then
        ln -s "$out/bin/''${jsFile:5:-3}" "$out/$jsFile"
      else
        install -m755 "$jsFile" -T $out/$jsFile
      fi
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    cacert
    versionCheckHook
  ];
  # Built-in SQLite support is only available in Node.js 22+, and required to run the tests.
  preInstallCheck = lib.optional (lib.versionAtLeast nodejs.version "22") ''
    # Exclude test files that require internet access.
    NOCK_ENV=replay yarn test --reporter tap --exclude tests/config.test.ts --exclude tests/Use.test.ts
  '';
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/nodejs/corepack/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Package manager version manager for Node.js projects";
    homepage = "https://github.com/nodejs/corepack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    mainProgram = "corepack";
  };
})
