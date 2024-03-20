{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, python3
, yarn
, electron
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marktext";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "marktext";
    repo = "marktext";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kCBF0rIYcnTT8YVH0k4F2UF7eXZ+/gFcFU+q3+1WF8A=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-Jkq40BXC7wNolIfYbK2eu0U3YH7jH+zEnrOxMFz5AVQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    prefetch-yarn-deps
    python3
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

    yarn --offline build:dev
    yarn --offline electron-builder \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # TODO

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple and elegant markdown editor, available for Linux, macOS and Windows";
    homepage = "https://marktext.app";
    license = licenses.mit;
    maintainers = with maintainers; [ nh2 eduarrrd ];
    mainProgram = "marktext";
  };
})
