{
  cctools,
  buildNpmPackage,
  curl,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  frida-node-prebuilds,
  lib,
  node-gyp,
  nodejs_22,
  python3,
  removeReferencesTo,
  stdenv,
  srcOnly,
}:

let
  fridaVersion = frida-node-prebuilds.fridaVersion;
  frida16Version = frida-node-prebuilds.frida16Version;
  nodeSources = srcOnly nodejs_22;
  radare2Version = "6.1.2";

  grapefruitSrc = fetchFromGitHub {
    owner = "ChiChou";
    repo = "grapefruit";
    rev = "v1.1.2";
    hash = "sha256-5zd9QNuumNJ3EU0Cx7YU8LIEqP50U820S0UnE9AksBc=";
  };

  radare2Wasm = fetchzip {
    url = "https://github.com/radareorg/radare2/releases/download/${radare2Version}/radare2-${radare2Version}-wasi-api.zip";
    hash = "sha256-HLXTG3gSAamN3BYxYshdOZgYjhtfYUaUW+QMJp+FB3w=";
    stripRoot = false;
  };
in
buildNpmPackage (finalAttrs: {
  pname = "igf";
  version = "1.1.2";

  __structuredAttrs = true;

  nodejs = nodejs_22;

  # The npm release ships the built CLI and web assets that are absent from the Git tag.
  src = fetchurl {
    url = "https://registry.npmjs.org/igf/-/igf-${finalAttrs.version}.tgz";
    hash = "sha256-sR5Jscjp7SySGnSVXKB7NJfn9HOZTfAMJmj1qXWqB0k=";
  };
  sourceRoot = "package";

  npmDepsHash = "sha256-9tkptyaLCogmjeokULdt0zxrXA/wSuMm+Mf6WM714Vo=";
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    node-gyp
    python3
    removeReferencesTo
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;

  nativeInstallCheckInputs = [
    curl
    python3
  ];

  dontNpmBuild = true;

  postPatch = ''
    # With __structuredAttrs, npmDeps is declared without -x so subprocesses (prefetchNpmDeps) can't see it.
    export npmDeps

    # The published npm tarball omits the lockfile, but the dependency graph is still defined upstream.
    cp ${grapefruitSrc}/package-lock.json package-lock.json

    mkdir -p externals/radare/r2hermes.wasm/dist
    cp -r ${grapefruitSrc}/externals/radare/r2hermes.wasm/. externals/radare/r2hermes.wasm/
    install -Dm444 gui/dist/hbc.wasm externals/radare/r2hermes.wasm/dist/hbc.wasm
  '';

  preBuild = ''
    mkdir -p node_modules/frida/build node_modules/frida16/build

    # Upstream supports runtime selection between Frida 17 and 16 depending on target compatibility.
    cp ${frida-node-prebuilds}/frida/build/frida_binding.node node_modules/frida/build/frida_binding.node
    cp ${frida-node-prebuilds}/frida16/build/frida_binding.node node_modules/frida16/build/frida_binding.node

    pushd node_modules/better-sqlite3
    npm run build-release --offline --nodedir="${nodeSources}"
    rm -r build/Release/{.deps,obj,obj.target,sqlite3.a,test_extension.node}
    find build -type f -exec remove-references-to -t "${nodeSources}" {} \;
    popd
  '';

  installPhase = ''
    runHook preInstall

    packageOut=$out/lib/node_modules/igf
    mkdir -p "$packageOut"

    npm prune --omit=dev --no-save --ignore-scripts
    find node_modules -maxdepth 1 -type d -empty -delete

    cp -r \
      agent \
      dist \
      drizzle \
      externals \
      gui \
      skills \
      "$packageOut/"
    install -Dm444 LICENSE "$packageOut/LICENSE"
    install -Dm444 README.md "$packageOut/README.md"
    install -Dm444 package.json "$packageOut/package.json"
    cp -r node_modules "$packageOut/"

    nodejsInstallExecutables package.json

    runHook postInstall
  '';

  postInstall = ''
    install -Dm444 ${radare2Wasm}/radare2-${radare2Version}-wasi-api/radare2.wasm \
      $out/lib/node_modules/igf/radare2.wasm
  '';

  # The installCheck starts the igf server and polls its HTTP API, which requires loading
  # the frida native binding (.node). On Darwin, macOS Hardened Runtime blocks unsigned
  # native binaries from loading in non-interactive build contexts, so the server never
  # becomes ready. The package itself installs correctly on Darwin.
  doInstallCheck = stdenv.hostPlatform.isLinux;
  installCheckPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    runHook preInstallCheck

    export HOME="$TMPDIR"
    export PROJECT_DIR="$TMPDIR/igf"

    checkVersion() {
      local fridaMajor="$1"
      local expectedFridaVersion="$2"
      local port="$3"
      local versionJson="version-$fridaMajor.json"

      (
        $out/bin/igf --frida "$fridaMajor" --host 127.0.0.1 --port "$port" >"server-$fridaMajor.log" 2>&1 &
        pid=$!

        cleanup() {
          kill "$pid" 2>/dev/null || true
          wait "$pid" 2>/dev/null || true
        }
        trap cleanup EXIT

        for _ in $(seq 1 30); do
          if curl --silent --fail "http://127.0.0.1:$port/api/version" >"$versionJson"; then
            break
          fi
          if ! kill -0 "$pid" 2>/dev/null; then
            cat "server-$fridaMajor.log"
            exit 1
          fi
          sleep 1
        done

        test -f "$versionJson"

        python3 -c 'import json, pathlib, sys; data = json.loads(pathlib.Path(sys.argv[1]).read_text()); assert data["frida"] == sys.argv[2]; assert data["igf"] == sys.argv[3]' \
          "$versionJson" "$expectedFridaVersion" "${finalAttrs.version}"
      )
    }

    checkVersion 17 "${fridaVersion}" 43137
    checkVersion 16 "${frida16Version}" 43138

    runHook postInstallCheck
  '';

  meta = {
    description = "Runtime mobile application instrumentation toolkit powered by Frida";
    homepage = "https://github.com/ChiChou/grapefruit";
    changelog = "https://github.com/ChiChou/grapefruit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caverav ];
    mainProgram = "igf";
    platforms = frida-node-prebuilds.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
