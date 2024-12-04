{ stdenv
, fetchYarnDeps
, fixup-yarn-lock
, yarn
, src
, version
, nodejs
, eintopf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eintopf";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/backstage";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/backstage/yarn.lock";
    hash = "sha256-7Br2FBhLZf7Cuul5n55EHfqyW8GbujB+yZ/RK6f7I4M=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
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

    mkdir -p "$out"
    cp -r . $out/

    runHook postInstall
  '';

  meta = {
    inherit (eintopf.meta) homepage description license maintainers;
  };
})
