{
  lib,
  stdenvNoCC,
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
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-uboftr6iRQ3QSDIi3nf/p/hsjDXJxJ7DO/gp/8qYFGk=";
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    sed \
      -e 's#require.resolve("corepack/package.json")#"${placeholder "out"}"#' \
      dist/lib/corepack.cjs > $out/lib/corepack.cjs
    node -p 'Object.keys(require("./package.json").publishConfig.bin).join("\n")' | while read -r binName; do
      echo "Preparing bin/$binName"
      sed \
        -e 's#./lib/corepack.cjs#../lib/corepack.cjs#' \
        "dist/$binName.js" > "$out/bin/$binName"
      chmod +x "$out/bin/$binName"
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
