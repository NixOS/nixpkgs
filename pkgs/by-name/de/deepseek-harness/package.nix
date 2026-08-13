{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeBinaryWrapper,
  node-gyp,
  nodejs_24,
  nodejs-slim_24,
  pkgsMusl,
  pnpmConfigHook,
  pnpm_11,
  python3,
  stdenv,
  versionCheckHook,
}:

let
  runtimeNode = nodejs-slim_24;
  pnpm = pnpm_11.override { nodejs-slim = runtimeNode; };

  landlockPackage =
    if stdenv.hostPlatform.isAarch64 then
      "node-addon-landlock-run-linux-arm64"
    else
      "node-addon-landlock-run-linux-x64";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "deepseek-harness";
  version = "0.1.0-rc.5";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "deepseek-harness";
    rev = "47f943859bef60e4160492346772ded9b24f765a";
    hash = "sha256-ZPGCNoPXVjP76Tm/tFPDX2X95cd83M4iHLmVP5dR+Ps=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-aySHq0ywTMM5q7YuGHZrV3yQE3bwppgGfWH3wRnHCXk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    node-gyp
    nodejs_24
    pnpm
    pnpmConfigHook
    python3
  ];

  disallowedReferences = [
    node-gyp
    nodejs_24
    python3
  ];

  postPatch = ''
    substituteInPlace native/landlock-run/scripts/build.ts \
      --replace-fail \
        "'musl-gcc'" \
        "'${lib.getExe pkgsMusl.stdenv.cc}'"

    # Keep virtual CSS module IDs relative so Rolldown does not embed the build root.
    substituteInPlace packages/client/tsdown.client.ts \
      --replace-fail \
        'return CSS_VIRTUAL_PREFIX + abs + CSS_VIRTUAL_SUFFIX' \
        'return CSS_VIRTUAL_PREFIX + relative(process.cwd(), abs) + CSS_VIRTUAL_SUFFIX' \
      --replace-fail \
        'const fileId = virtualId.slice(CSS_VIRTUAL_PREFIX.length, -CSS_VIRTUAL_SUFFIX.length)' \
        'const fileId = resolvePath(virtualId.slice(CSS_VIRTUAL_PREFIX.length, -CSS_VIRTUAL_SUFFIX.length))' \
      --replace-fail \
        'Object.entries(cssExports ?? {})' \
        'Object.entries(cssExports ?? {}).sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)'
  '';

  buildPhase = ''
    runHook preBuild

    GITHUB_ACTIONS=true pnpm rebuild
    pnpm run build
    pnpm --dir native/landlock-run run build:native

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    deployDir="$NIX_BUILD_TOP/dsh-deploy"
    app="$out/lib/node_modules/@deepseek-ai/dsh"

    npm_config_ignore_scripts=true \
      pnpm \
        --offline \
        --ignore-scripts \
        --filter @deepseek-ai/dsh \
        --prod \
        --config.inject-workspace-packages=true \
        --config.link-workspace-packages=true \
        --config.node-linker=hoisted \
        deploy "$deployDir"

    # dsh-app-boot imports this peer, but apps/cli does not declare it.
    cp -a \
      vendor/group \
      "$deployDir/node_modules/@deepseek-ai/cordis-plugin-group"

    rm -rf \
      "$deployDir/node_modules/@deepseek-ai/cordis-plugin-group/node_modules"

    # Several workspace packages import runtime dependencies declared as devDependencies.
    for package in \
      packages/code-runtime/code-runtime \
      packages/compaction/compaction \
      packages/core/scope \
      packages/fs/fs \
      packages/identity/anonymous-user-id \
      packages/sandbox/sandbox \
      packages/session/session-telemetry \
      packages/session/session-title-llm \
      packages/shell/bash-local \
      packages/shell/shell \
      packages/spill/spill \
      packages/subagent/subagent-in-process-driver \
      packages/subprocess/subprocess \
      packages/util/atomic-write \
      packages/util/output-retention \
      packages/util/timeout \
      packages/workflow/workflow
    do
      name="$(node -p "require('./$package/package.json').name.split('/')[1]")"
      mkdir -p "$deployDir/node_modules/@deepseek-ai/$name"
      cp -a \
        "$package/package.json" \
        "$package/lib" \
        "$deployDir/node_modules/@deepseek-ai/$name/"
    done

    if [[ -d "$deployDir/node_modules/koffi" ]]; then
      (
        cd "$deployDir/node_modules/koffi"
        node ./cnoke.cjs \
          -P . \
          -D src/koffi \
          --prebuild \
          --release
      )
    fi

    if [[ -d "$deployDir/node_modules/node-pty" ]]; then
      (
        cd "$deployDir/node_modules/node-pty"
        node scripts/prebuild.js || node-gyp rebuild
        node scripts/post-install.js
      )
    fi

    if [[ -d "$deployDir/node_modules/@deepseek-ai/dsh-subprocess-local" ]]; then
      (
        cd "$deployDir/node_modules/@deepseek-ai/dsh-subprocess-local"
        node scripts/ensure-spawn-helper.mjs
      )
    fi

    mkdir -p "$app" "$out/bin"
    cp -a "$deployDir/." "$app/"

    # pnpm deploy rewrites workspace dependencies to build-directory file URLs.
    cp apps/cli/package.json "$app/package.json"

    rm -f \
      "$app/pnpm-lock.yaml" \
      "$app/node_modules/.modules.yaml" \
      "$app/node_modules/.pnpm/lock.yaml" \
      "$app/node_modules/.pnpm-workspace-state-v1.json"

    if [[ -d "$app/node_modules/node-pty/prebuilds" ]]; then
      rm -rf \
        "$app/node_modules/node-pty/prebuilds"/darwin-* \
        "$app/node_modules/node-pty/prebuilds"/win32-*
    fi

    if [[ -d "$app/node_modules/node-pty/build" ]]; then
      find "$app/node_modules/node-pty/build" -type f \
        ! -path '*/Release/pty.node' -delete
      find "$app/node_modules/node-pty/build" -depth -type d -empty -delete
    fi

    rm -rf "$app/node_modules/node-pty/node-addon-api"

    ${lib.optionalString stdenv.hostPlatform.isx86_64 ''
      rm -rf \
        "$app/node_modules/@deepseek-ai/node-addon-landlock-run-linux-arm64"
    ''}

    ${lib.optionalString stdenv.hostPlatform.isAarch64 ''
      rm -rf \
        "$app/node_modules/@deepseek-ai/node-addon-landlock-run-linux-x64"
    ''}

    # Nix-built Node currently needs this for the HMR loader used by dsh web.
    makeBinaryWrapper ${lib.getExe runtimeNode} "$out/bin/dsh" \
      --add-flags "--expose-internals" \
      --add-flags "$app/lib/bin.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          runtimeNode
          pnpm
        ]
      }

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  postInstallCheck = ''
    app="$out/lib/node_modules/@deepseek-ai/dsh"

    "$out/bin/dsh" --help > /dev/null

    runtimeHome="$(mktemp -d)"

    env -i \
      HOME="$runtimeHome" \
      DSH_HOME="$runtimeHome/dsh" \
      PATH="$out/bin" \
      "$out/bin/dsh" \
        --profile headless \
        --dump-default-config > /dev/null

    env -i \
      HOME="$runtimeHome" \
      DSH_HOME="$runtimeHome/dsh" \
      PATH="$out/bin" \
      "$out/bin/dsh" \
        plugin \
        --profile install-check \
        --version \
      | grep -Fx ${lib.escapeShellArg pnpm.version}

    webHome="$(mktemp -d)"
    webLog="$(mktemp)"

    env -i \
      HOME="$webHome" \
      DSH_HOME="$webHome/dsh" \
      PATH="$out/bin" \
      "$out/bin/dsh" \
        web \
        --host 127.0.0.1 \
        --port 0 > "$webLog" 2>&1 &

    webPid=$!

    cleanupWeb() {
      kill "$webPid" 2> /dev/null || true
      wait "$webPid" 2> /dev/null || true
    }

    trap cleanupWeb EXIT

    for _ in {1..100}; do
      if ! kill -0 "$webPid" 2> /dev/null; then
        cat "$webLog" >&2
        exit 1
      fi

      webUrl="$(sed -n 's/^dsh web: //p' "$webLog")"

      if [[ -n "$webUrl" ]]; then
        break
      fi

      sleep 0.1
    done

    test -n "''${webUrl:-}"

    WEB_URL="$webUrl" ${lib.getExe runtimeNode} <<'NODE'
    const response = await fetch(process.env.WEB_URL);

    if (!response.ok) {
      process.exit(1);
    }

    const html = await response.text();

    if (!html.includes("<html")) {
      process.exit(1);
    }
    NODE

    cleanupWeb
    trap - EXIT

    APP="$app" ${lib.getExe runtimeNode} <<'NODE'
    const path = require("node:path");

    const pty = require(
      path.join(process.env.APP, "node_modules/node-pty"),
    );

    require(path.join(process.env.APP, "node_modules/koffi"));
    require(path.join(process.env.APP, "node_modules/sharp"));
    require(
      path.join(
        process.env.APP,
        "node_modules/node-addon-require-builtin",
      ),
    );

    const child = pty.spawn(
      "${stdenv.shell}",
      ["-c", "printf dsh-nix-pty-ok"],
      {
        cols: 80,
        rows: 24,
      },
    );

    let output = "";

    const timeout = setTimeout(() => {
      child.kill();
      process.exit(1);
    }, 5000);

    child.onData((data) => {
      output += data;
    });

    child.onExit(({ exitCode }) => {
      clearTimeout(timeout);

      if (
        exitCode !== 0 ||
        !output.includes("dsh-nix-pty-ok")
      ) {
        process.exit(1);
      }
    });
    NODE

    landlock="$app/node_modules/@deepseek-ai/${landlockPackage}/bin/landlock-run"

    test -x "$landlock"

    "$landlock" --probe \
      | grep -Eq '^landlock: (fully|partially) enforced$'

    if find "$out" -xtype l -print -quit | grep -q .; then
      find "$out" -xtype l -print >&2
      exit 1
    fi

    if grep -RlaE '/build/(source|tmp\.|\.home)' "$out"; then
      exit 1
    fi
  '';

  meta = {
    description = "Open-source agent harness developed by DeepSeek AI";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alephcasara ];
    mainProgram = "dsh";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
