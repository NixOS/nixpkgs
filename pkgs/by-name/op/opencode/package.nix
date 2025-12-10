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
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.0.133";

  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aWzNnu7ZZovgIYQ59ErC/fKpenoFq/wcoizeQ5Ilnq8=";
  };

  bunWorkspaces = [ "./packages/opencode" ];
  bunDeps = bun.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      bunWorkspaces
      ;
    hash = "sha256-5LGd4Tn0wlIk5bFH0El/YTAdP4jqPvpQq0gWOBsSDZA=";

    postInstall = ''
      bun run ./nix/scripts/canonicalize-node-modules.ts
      bun run ./nix/scripts/normalize-bun-binaries.ts
    '';
  };

  nativeBuildInputs = [
    bun.configHook
    makeBinaryWrapper
    models-dev
  ];

  patches = [
    # NOTE: Relax Bun version check to be a warning instead of an error
    ./relax-bun-version-check.patch
  ];

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.OPENCODE_VERSION = finalAttrs.version;
  env.OPENCODE_CHANNEL = "stable";

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

    runHook postBuild
  '';

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

    mkdir -p $out/bin
    makeWrapper ${lib.getExe bun} $out/bin/opencode \
      --add-flags "run" \
      --add-flags "$out/lib/opencode/dist/index.js" \
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
    for pkg in $out/lib/opencode/node_modules/.bun/@opentui+core-*; do
      if [ -d "$pkg" ]; then
        pkgName=$(basename "$pkg" | sed 's/@opentui+\(core-[^@]*\)@.*/\1/')
        ln -sf ../.bun/$(basename "$pkg")/node_modules/@opentui/$pkgName \
               $out/lib/opencode/node_modules/@opentui/$pkgName
      fi
    done
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) opencode --version";
      inherit (finalAttrs) version;
    };
    updateScript = nix-update-script { };
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
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "opencode";
  };
})
