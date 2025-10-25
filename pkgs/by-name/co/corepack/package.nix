{
  lib,
  stdenvNoCC,
  cacert,
  yarn-berry,
  nodejs,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "corepack";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "corepack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dZ5gVcrBNeyyZ10rU0HQaHUisL3sBZanTusPjMME8lk=";
  };

  patches = [
    ./sqlite.patch
  ];

  nodejs = nodejs;
  nativeBuildInputs = [
    finalAttrs.nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];
  buildInputs = [
    finalAttrs.nodejs
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    nodejs = finalAttrs.nodejs;
    hash = "sha256-uboftr6iRQ3QSDIi3nf/p/hsjDXJxJ7DO/gp/8qYFGk=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin $out/dist
    sed \
      -e 's#require.resolve("corepack/package.json")#"${placeholder "out"}/bin"#' \
      dist/lib/corepack.cjs > $out/lib/corepack.cjs
    node -p 'Object.keys(require("./package.json").publishConfig.bin).join("\0")' | while IFS= read -r -d "" binName; do
      echo "Installing bin/$binName"
      sed \
        -e 's#./lib/corepack.cjs#../lib/corepack.cjs#' \
        "dist/$binName.js" > "$out/bin/$binName"
      chmod +x "$out/bin/$binName"
    done
    find dist -maxdepth 1 -name "*.js" -print0 | while IFS= read -r -d "" jsFile; do
      echo "Installing $jsFile"
      if [ -f "$out/bin/''${jsFile:5:-3}" ]; then
        ln -s "$out/bin/''${jsFile:5:-3}" "$out/$jsFile"
      else
        sed \
          -e 's#./lib/corepack.cjs#../lib/corepack.cjs#' \
          "$jsFile" > "$out/$jsFile"
        chmod +x "$out/$jsFile"
      fi
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    cacert
    versionCheckHook
  ];
  preInstallCheck = ''
    substituteInPlace tests/_runCli.ts --replace-fail 'require.resolve(`../dist/corepack.js`)' "'$out/bin/corepack'"
    substituteInPlace tests/main.test.ts --replace-fail 'npath.dirname(__dirname)' "'$out'"
    substituteInPlace tests/Enable.test.ts --replace-fail 'skipIf(process.platform === `win32`)' 'skip'
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
