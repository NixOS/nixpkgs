{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, fixup-yarn-lock
, yarn
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marp-cli";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-azscuPkQ9/xcQtBg+5pJigXSQQVtBGvbd7ZwiLwU7Qo=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-b/JyhsfXEbmM6+ajrjL65WhX9u9MEH+m1NHE6cTyf2g=";
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

    mkdir -p $out/lib/node_modules/@marp-team/marp-cli
    cp -r lib node_modules marp-cli.js $out/lib/node_modules/@marp-team/marp-cli/

    makeWrapper "${nodejs}/bin/node" "$out/bin/marp" \
      --add-flags "$out/lib/node_modules/@marp-team/marp-cli/marp-cli.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ GuillaumeDesforges ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
})
