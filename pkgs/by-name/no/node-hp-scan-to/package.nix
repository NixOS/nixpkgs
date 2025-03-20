{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  fixup-yarn-lock,
  yarn,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "node-hp-scan-to";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "manuc66";
    repo = "node-hp-scan-to";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/XUqCL2F1iMYUoCbGgL9YKs+8wIFHvmh2O0LMbDU8yE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-pxeYumHuomOFyCi8XhYTYQNcsGOUvjOg36bFD0yhdLk=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    fixup-yarn-lock
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/node-hp-scan-to"
    cp -r dist node_modules package.json "$out/lib/node_modules/node-hp-scan-to"

    makeWrapper "${nodejs}/bin/node" "$out/bin/node-hp-scan-to" \
      --add-flags "$out/lib/node_modules/node-hp-scan-to/dist/index.js"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/manuc66/node-hp-scan-to/releases/tag/${finalAttrs.src.rev}";
    description = "Allow to send scan from device to computer for some HP All-in-One Printers";
    homepage = "https://github.com/manuc66/node-hp-scan-to";
    license = lib.licenses.mit;
    mainProgram = "node-hp-scan-to";
    maintainers = with lib.maintainers; [ jonas-w ];
  };
})
