{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  patchelf,
  srcOnly,
  python3,
  removeReferencesTo,
  stdenv,
  cctools,
}:

let
  pin = lib.importJSON ./pin.json;
  version = pin.version;
  pname = "perplexica-backend";
  nodeSources = srcOnly nodejs;

  src = fetchFromGitHub {
    owner = "ItzCrazyKns";
    repo = "Perplexica";
    rev = "v${version}";
    hash = pin.srcHash;
  };

  passthru = {
    nodeAppDir = "libexec/${pname}/deps/${pname}";
    updateScript = ./update.sh;
  };
in
mkYarnPackage {
  inherit
    version
    pname
    src
    passthru
    ;

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = pin.yarnSha256;
  };

  nativeBuildInputs = [
    makeWrapper
    patchelf
  ];

  buildPhase = ''
    runHook preBuild

    # compile TypeScript sources
    yarn --offline build

    runHook postBuild
  '';

  pkgConfig = {
    better-sqlite3 = {
      nativeBuildInputs = [ python3 ] ++ lib.optionals stdenv.isDarwin [ cctools ];
      postInstall = ''
        # build native sqlite bindings
        npm run build-release --offline --nodedir="${nodeSources}"
        find build -type f -exec \
          ${removeReferencesTo}/bin/remove-references-to \
          -t "${nodeSources}" {} \;
      '';
    };
  };

  doCheck = false;

  postInstall = ''
    OUT_JS_DIR="$out/${passthru.nodeAppDir}/dist"

    # server wrapper
    makeWrapper '${nodejs}/bin/node' "$out/bin/${pname}" \
      --add-flags "$OUT_JS_DIR/app.js"
  '';

  # don't generate the dist tarball
  doDist = false;

  meta = {
    description = "Perplexica is an AI-powered search engine. It is an Open source alternative to Perplexity AI";
    homepage = "https://github.com/ItzCrazyKns/Perplexica";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.all;
    mainProgram = pname;
  };
}
