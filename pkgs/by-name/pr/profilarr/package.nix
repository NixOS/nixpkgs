{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  deno,
  cacert,
  jq,
  python3,
  makeWrapper,
  git,
  gnutar,
  sqlite,
  nix-update-script,
}:
let
  # Upstream's lock omits the JSR imports introduced by the server adapter.
  # Regenerate this overlay with `deno cache --lock=deno.lock
  # jsr:@std/http@1/file-server jsr:@std/path@1`, retaining only changed entries.
  mergeAdapterLock = ''
    jq -s '.[0] * .[1]' deno.lock ${./adapter-lock.json} > deno.lock.merged
    mv deno.lock.merged deno.lock
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "profilarr";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Dictionarry-Hub";
    repo = "profilarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b+76GvuNIFIrf+Sts+uFERtCtqW/vORbS9X2YF4Uhkg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    deno
    jq
    makeWrapper
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  dontConfigure = true;
  # ELF rewriting would corrupt the JavaScript payload appended by deno compile.
  dontStrip = true;
  dontPatchELF = true;

  postPatch = ''
    substituteInPlace src/lib/shared/build.ts \
      --replace-fail "version: 'dev'" "version: '${finalAttrs.version}'" \
      --replace-fail "channel: 'dev'" "channel: 'stable'"
    ${mergeAdapterLock}
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR/home DENO_DIR=$TMPDIR/cache APP_BASE_PATH=$TMPDIR/state
    mkdir -p "$HOME"
    cp -r ${finalAttrs.passthru.dependencies}/cache "$DENO_DIR"
    cp -r ${finalAttrs.passthru.dependencies}/node_modules node_modules
    chmod -R u+w "$DENO_DIR" node_modules
    export VITE_PLATFORM=linux-amd64 VITE_CHANNEL=stable
    export DENO_SQLITE_PATH=${sqlite.out}/lib/libsqlite3.so
    deno run --cached-only -A vite build
    DENORT_BIN=${lib.getExe' deno.denort "denort"} deno compile --cached-only --no-check -A --output dist/build/profilarr dist/build/mod.ts

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/profilarr/deno-cache" "$out/bin"
    cp -r dist/build/profilarr dist/build/server.js dist/build/static "$out/lib/profilarr/"
    cp -r "$DENO_DIR/plug" "$out/lib/profilarr/deno-cache/"
    makeWrapper "$out/lib/profilarr/profilarr" "$out/bin/profilarr" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          gnutar
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]} \
      --set DENO_DIR "$out/lib/profilarr/deno-cache" \
      --set DENO_SQLITE_PATH ${sqlite.out}/lib/libsqlite3.so

    runHook postInstall
  '';

  passthru = {
    dependencies = stdenvNoCC.mkDerivation (finalDeps: {
      pname = "profilarr-dependencies";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        deno
        cacert
        jq
        python3
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export HOME=$TMPDIR/home DENO_DIR=$out/cache
        mkdir -p "$HOME" "$out"
        ${mergeAdapterLock}
        deno ci
        deno cache --frozen jsr:@std/http@1/file-server jsr:@std/path@1
        # Populate the native bcrypt plugin cache before entering the offline build.
        LD_LIBRARY_PATH=${
          lib.makeLibraryPath [ stdenv.cc.cc.lib ]
        } deno eval --frozen "import { hash } from '@felix/bcrypt'; await hash('profilarr')"
        cp -r node_modules "$out/node_modules"
        find "$out" -type l -lname '/nix/store/*' -delete
        rm -rf "$DENO_DIR/gen"
        # Remove timestamps, volatile headers and unlocked registry versions.
        python3 ${./normalize-deno-cache.py} "$DENO_DIR" deno.lock

        runHook postBuild
      '';

      dontInstall = true;
      dontFixup = true;
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-qzbxDneYIlrAuKinBRg6eIvEwcp+VeUpVCHjpL6lkW8=";
    });
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--subpackage"
        "dependencies"
      ];
    };
  };

  meta = {
    description = "Configuration management for Radarr and Sonarr";
    homepage = "https://github.com/Dictionarry-Hub/profilarr";
    changelog = "https://github.com/Dictionarry-Hub/profilarr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ shgew ];
    mainProgram = "profilarr";
    # The dependency cache includes platform-specific npm packages and bcrypt.
    platforms = [ "x86_64-linux" ];
  };
})
