{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  fzf,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  ripgrep,
  testers,
  writableTmpDirAsHomeHook,
}:
let
  pname = "opencode";
<<<<<<< HEAD
  version = "1.0.210";
=======
  version = "1.0.119";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0bWhOquP17U7F2NO+f8pubulqfOG03wMxzPpD/yqe3A=";
=======
    hash = "sha256-U2oIEXhAWOaOZHGBlVUPgysW0AtEh/P8LxbGlm8Lquk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --cpu="*" \
        --filter=./packages/opencode \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*" \
        --production

      bun run ./nix/scripts/canonicalize-node-modules.ts
      bun run ./nix/scripts/normalize-bun-binaries.ts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # NOTE: Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

<<<<<<< HEAD
    outputHash = "sha256-P9ZiSW8aZWEUGE1OCej/S2biyJzSwlObcuRzBxJsEZU=";
=======
    outputHash = "sha256-rGmHVBhsyOmPD4kG8k0hhER5pZn2KVwBXk0O8MER8jc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    node_modules
    ;

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    models-dev
  ];

  patches = [
    # NOTE: Relax Bun version check to be a warning instead of an error
    ./relax-bun-version-check.patch
  ];

<<<<<<< HEAD
  dontConfigure = true;
=======
  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/. .

    runHook postConfigure
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.OPENCODE_VERSION = finalAttrs.version;
  env.OPENCODE_CHANNEL = "stable";

<<<<<<< HEAD
  buildPhase = ''
    runHook preBuild

    # Copy all node_modules including the .bun directory with actual packages
    cp -r ${finalAttrs.node_modules}/node_modules .
    cp -r ${finalAttrs.node_modules}/packages .

    (
      cd packages/opencode

      # Fix symlinks to workspace packages
      chmod -R u+w ./node_modules
      mkdir -p ./node_modules/@opencode-ai
      rm -f ./node_modules/@opencode-ai/{script,sdk,plugin}
      ln -s $(pwd)/../../packages/script ./node_modules/@opencode-ai/script
      ln -s $(pwd)/../../packages/sdk/js ./node_modules/@opencode-ai/sdk
      ln -s $(pwd)/../../packages/plugin ./node_modules/@opencode-ai/plugin

      # Use upstream bundle.ts for Nix-compatible bundling
      cp ../../nix/bundle.ts ./bundle.ts
      chmod +x ./bundle.ts
      bun run ./bundle.ts
    )
=======
  preBuild = ''
    chmod -R u+w ./packages/opencode/node_modules
    pushd ./packages/opencode/node_modules/@parcel/
      for pkg in ../../../../node_modules/.bun/@parcel+watcher-*; do
        linkName=$(basename "$pkg" | sed 's/@.*+\(.*\)@.*/\1/')
        ln -sf "$pkg/node_modules/@parcel/$linkName" "$linkName"
      done
    popd

    pushd ./packages/opencode/node_modules/@opentui/
      for pkg in ../../../../node_modules/.bun/@opentui+core-*; do
        linkName=$(basename "$pkg" | sed 's/@.*+\(.*\)@.*/\1/')
        ln -sf "$pkg/node_modules/@opentui/$linkName" "$linkName"
      done
    popd
  '';

  buildPhase = ''
    runHook preBuild


    cd ./packages/opencode
    cp ${./bundle.ts} ./bundle.ts
    bun run ./bundle.ts
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postBuild
  '';

<<<<<<< HEAD
  installPhase = ''
    runHook preInstall

    cd packages/opencode
    if [ ! -d dist ]; then
      echo "ERROR: dist directory missing after bundle step"
      exit 1
    fi

    mkdir -p $out/lib/opencode
    cp -r dist $out/lib/opencode/
    chmod -R u+w $out/lib/opencode/dist

    # Select bundled worker assets deterministically (sorted find output)
    worker_file=$(find "$out/lib/opencode/dist" -type f \( -path '*/tui/worker.*' -o -name 'worker.*' \) | sort | head -n1)
    parser_worker_file=$(find "$out/lib/opencode/dist" -type f -name 'parser.worker.*' | sort | head -n1)
    if [ -z "$worker_file" ]; then
      echo "ERROR: bundled worker not found"
      exit 1
    fi

    main_wasm=$(printf '%s\n' "$out"/lib/opencode/dist/tree-sitter-*.wasm | sort | head -n1)
    wasm_list=$(find "$out/lib/opencode/dist" -maxdepth 1 -name 'tree-sitter-*.wasm' -print)
    for patch_file in "$worker_file" "$parser_worker_file"; do
      [ -z "$patch_file" ] && continue
      [ ! -f "$patch_file" ] && continue
      if [ -n "$wasm_list" ] && grep -q 'tree-sitter' "$patch_file"; then
        # Rewrite wasm references to absolute store paths to avoid runtime resolve failures.
        bun --bun ../../nix/scripts/patch-wasm.ts "$patch_file" "$main_wasm" $wasm_list
      fi
    done

    mkdir -p $out/lib/opencode/node_modules
    cp -r ../../node_modules/.bun $out/lib/opencode/node_modules/
    mkdir -p $out/lib/opencode/node_modules/@opentui

    # Generate and install JSON schema
    mkdir -p $out/share/opencode
    HOME=$TMPDIR bun --bun script/schema.ts $out/share/opencode/schema.json
=======
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/opencode
    # Copy the bundled dist directory
    cp -r dist $out/lib/opencode/

    # Fix WASM paths in worker.ts - use absolute paths to the installed location
    # Main wasm is tree-sitter-<hash>.wasm, language wasms are tree-sitter-<lang>-<hash>.wasm
    main_wasm=$(find "$out/lib/opencode/dist" -maxdepth 1 -name 'tree-sitter-[a-z0-9]*.wasm' -print -quit)

    substituteInPlace $out/lib/opencode/dist/worker.ts \
      --replace-fail 'module2.exports = "../../../tree-sitter-' 'module2.exports = "'"$out"'/lib/opencode/dist/tree-sitter-' \
      --replace-fail 'new URL("tree-sitter.wasm", import.meta.url).href' "\"$main_wasm\""

    # Copy only the native modules we need (marked as external in bundle.ts)
    mkdir -p $out/lib/opencode/node_modules/.bun
    mkdir -p $out/lib/opencode/node_modules/@opentui

    # Copy @opentui/core platform-specific packages
    for pkg in ../../node_modules/.bun/@opentui+core-*; do
      if [ -d "$pkg" ]; then
        cp -r "$pkg" $out/lib/opencode/node_modules/.bun/$(basename "$pkg")
      fi
    done
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    mkdir -p $out/bin
    makeWrapper ${lib.getExe bun} $out/bin/opencode \
      --add-flags "run" \
<<<<<<< HEAD
      --add-flags "$out/lib/opencode/dist/src/index.js" \
=======
      --add-flags "$out/lib/opencode/dist/index.js" \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      --prefix PATH : ${
        lib.makeBinPath [
          fzf
          ripgrep
        ]
      } \
      --argv0 opencode

    runHook postInstall
  '';

  postInstall = ''
    # Add symlinks for platform-specific native modules
<<<<<<< HEAD
    pkgs=(
      $out/lib/opencode/node_modules/.bun/@opentui+core-*
      $out/lib/opencode/node_modules/.bun/@opentui+solid-*
      $out/lib/opencode/node_modules/.bun/@opentui+core@*
      $out/lib/opencode/node_modules/.bun/@opentui+solid@*
    )
    for pkg in "''${pkgs[@]}"; do
      if [ -d "$pkg" ]; then
        pkgName=$(basename "$pkg" | sed 's/@opentui+\([^@]*\)@.*/\1/')
        ln -sf ../.bun/$(basename "$pkg")/node_modules/@opentui/$pkgName \
          $out/lib/opencode/node_modules/@opentui/$pkgName
=======
    for pkg in $out/lib/opencode/node_modules/.bun/@opentui+core-*; do
      if [ -d "$pkg" ]; then
        pkgName=$(basename "$pkg" | sed 's/@opentui+\(core-[^@]*\)@.*/\1/')
        ln -sf ../.bun/$(basename "$pkg")/node_modules/@opentui/$pkgName \
               $out/lib/opencode/node_modules/@opentui/$pkgName
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fi
    done
  '';

  passthru = {
<<<<<<< HEAD
    jsonschema = "${placeholder "out"}/share/opencode/schema.json";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) opencode --version";
      inherit (finalAttrs) version;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    longDescription = ''
      OpenCode is a terminal-based agent that can build anything.
      It combines a TypeScript/JavaScript core with a Go-based TUI
      to provide an interactive AI coding experience.
    '';
    homepage = "https://github.com/sst/opencode";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ delafthi ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "opencode";
  };
})
