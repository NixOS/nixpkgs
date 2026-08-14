{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeBinaryWrapper,
  node-gyp,
  nodejs_24,
  nodejs-slim_24,
  pkgsStatic,
  pnpmConfigHook,
  pnpm_11,
  python3,
  stdenv,
  versionCheckHook,
}:

let
  runtimeNode = nodejs-slim_24;
  pnpm = pnpm_11.override { nodejs-slim = runtimeNode; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "deepseek-harness";

  # rc.5 is pinned because rc.6 was published without matching public source and lockfile.
  version = "0.1.0-rc.5";

  __structuredAttrs = true;
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

  outputChecks.out.disallowedRequisites = [
    node-gyp
    nodejs_24
    python3
  ];

  postPatch = ''
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # Upstream hard-codes musl-gcc; use Nixpkgs' static-musl compiler in the sandbox.
      substituteInPlace native/landlock-run/scripts/build.ts \
        --replace-fail \
          "'musl-gcc'" \
          "'${lib.getExe pkgsStatic.stdenv.cc}'"
    ''}

    # Keep CSS IDs relative to avoid build-root references and sort exports for deterministic bundles.
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

    # pnpmConfigHook installs with lifecycle scripts disabled; rebuild the upstream allowlist.
    # CI mode prevents the root postinstall from mutating Git hooks.
    GITHUB_ACTIONS=true pnpm rebuild
    pnpm run build
    pnpm --dir native/landlock-run run build:native

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    deployDir="$NIX_BUILD_TOP/dsh-deploy"
    packDir="$NIX_BUILD_TOP/dsh-packs"
    app="$out/lib/node_modules/@deepseek-ai/dsh"

    mkdir -p "$packDir"

    # Use pnpm's lockfile-aware deploy path. Injection is required by pnpm 11;
    # the hoisted layout mirrors the npm installation shape upstream publishes for.
    pnpm \
      --offline \
      --ignore-scripts \
      --filter @deepseek-ai/dsh \
      --prod \
      --config.inject-workspace-packages=true \
      --config.node-linker=hoisted \
      deploy "$deployDir"

    # pnpm deploy can omit workspace packages that are required only through
    # peerDependencies. Derive the required peer closure from upstream manifests
    # and materialize only missing packages through pnpm pack, matching upstream's
    # published payload transformation instead of maintaining a downstream list.
    DEPLOY_DIR="$deployDir" PACK_DIR="$packDir" \
      node --input-type=module <<'NODE'
    import {
      existsSync,
      globSync,
      mkdirSync,
      readFileSync,
      rmSync,
    } from "node:fs";
    import { dirname, join } from "node:path";
    import { spawnSync } from "node:child_process";

    const deployDir = process.env.DEPLOY_DIR;
    const packDir = process.env.PACK_DIR;

    if (deployDir === undefined || packDir === undefined) {
      throw new Error("missing deployment paths");
    }

    const workspace = new Map();

    for (const manifestPath of [
      ...globSync("vendor/*/package.json"),
      ...globSync("packages/*/*/package.json"),
      ...globSync("native/landlock-run/packages/*/package.json"),
      ...globSync("apps/*/package.json"),
    ].sort()) {
      const manifest = JSON.parse(readFileSync(manifestPath, "utf8"));

      if (typeof manifest.name !== "string") {
        throw new Error("workspace manifest has no package name: " + manifestPath);
      }

      if (workspace.has(manifest.name)) {
        throw new Error("duplicate workspace package name: " + manifest.name);
      }

      workspace.set(manifest.name, {
        dir: dirname(manifestPath),
        manifest,
      });
    }

    const rootName = "@deepseek-ai/dsh";
    const packagePath = name =>
      join(deployDir, "node_modules", ...name.split("/"));

    if (!workspace.has(rootName)) {
      throw new Error("CLI workspace manifest not found");
    }

    const run = (command, args, options = {}) => {
      const result = spawnSync(command, args, {
        cwd: process.cwd(),
        env: process.env,
        stdio: "inherit",
        ...options,
      });

      if (result.error !== undefined || result.status !== 0) {
        throw new Error(command + " failed: " + args.join(" "));
      }
    };

    const materialize = name => {
      const entry = workspace.get(name);

      if (entry === undefined) {
        throw new Error("workspace package not found: " + name);
      }

      const optionalDependencies = Object.keys(
        entry.manifest.optionalDependencies ?? {},
      );

      if (optionalDependencies.length > 0) {
        throw new Error(
          name
            + " is missing from pnpm deploy but has optional dependencies: "
            + optionalDependencies.join(", "),
        );
      }

      const requiredExternal = [
        ...Object.keys(entry.manifest.dependencies ?? {}),
        ...Object.keys(entry.manifest.peerDependencies ?? {}).filter(
          peer => entry.manifest.peerDependenciesMeta?.[peer]?.optional !== true,
        ),
      ]
        .filter(dependency => !workspace.has(dependency))
        .filter(dependency => !existsSync(packagePath(dependency)));

      if (requiredExternal.length > 0) {
        throw new Error(
          name
            + " requires external runtime packages absent from pnpm deploy: "
            + [...new Set(requiredExternal)].sort().join(", "),
        );
      }

      const archive = join(
        packDir,
        name.replace(/^@/, "").replaceAll("/", "-") + ".tgz",
      );
      rmSync(archive, { force: true });

      run(
        "pnpm",
        ["--dir", entry.dir, "pack", "--out", archive],
        {
          env: {
            ...process.env,
            pnpm_config_ignore_scripts: "true",
          },
        },
      );

      const destination = packagePath(name);
      rmSync(destination, { force: true, recursive: true });
      mkdirSync(destination, { recursive: true });

      run(
        "tar",
        [
          "-xzf",
          archive,
          "--strip-components=1",
          "-C",
          destination,
        ],
      );

      rmSync(archive);
    };

    const materialized = [];

    while (true) {
      const missing = new Set();

      for (const [name, entry] of workspace) {
        if (name !== rootName && !existsSync(packagePath(name))) {
          continue;
        }

        const runtimeEdges = new Set(
          Object.keys(entry.manifest.dependencies ?? {}),
        );

        for (const peer of Object.keys(entry.manifest.peerDependencies ?? {})) {
          if (entry.manifest.peerDependenciesMeta?.[peer]?.optional !== true) {
            runtimeEdges.add(peer);
          }
        }

        for (const dependency of runtimeEdges) {
          if (
            workspace.has(dependency)
            && !existsSync(packagePath(dependency))
          ) {
            missing.add(dependency);
          }
        }
      }

      if (missing.size === 0) {
        break;
      }

      for (const name of [...missing].sort()) {
        materialize(name);
        materialized.push(name);
      }
    }

    if (materialized.length > 0) {
      console.log(
        "materialized workspace runtime peers: "
          + materialized.join(", "),
      );
    }
    NODE

    # deploy runs with lifecycle scripts disabled; recreate only native/runtime
    # artifacts needed by the final closure.
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
    cp -a "$deployDir/node_modules" "$app/"

    # pnpm deploy can preserve workspace: ranges in package.json. Install the CLI
    # from its upstream pack payload so the manifest matches what DeepSeek publishes.
    cliTar="$packDir/dsh-cli.tgz"
    pnpm_config_ignore_scripts=true \
      pnpm --dir apps/cli pack --out "$cliTar"
    tar -xzf "$cliTar" --strip-components=1 -C "$app"

    rm -f \
      "$cliTar" \
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

    # Only x86_64-linux is declared below; drop the unused arm64 optional package.
    rm -rf "$app/node_modules/@deepseek-ai/node-addon-landlock-run-linux-arm64"

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

    if grep -q 'workspace:' "$app/package.json"; then
      echo "packed CLI manifest still contains workspace: dependencies" >&2
      exit 1
    fi

    landlock="$(
      LANDLOCK_ENTRY="$app/node_modules/@deepseek-ai/node-addon-landlock-run/lib/index.js" \
        ${lib.getExe runtimeNode} --input-type=module --eval \
          'import { pathToFileURL } from "node:url"; const entry = await import(pathToFileURL(process.env.LANDLOCK_ENTRY)); process.stdout.write(entry.launcherPath());'
    )"

    test -x "$landlock"

    landlockProbe="$(mktemp)"

    if "$landlock" --probe > "$landlockProbe" 2>&1; then
      grep -Eq '^landlock: (fully|partially) enforced' "$landlockProbe"

      allowedDir="$(mktemp -d)"
      deniedDir="$(mktemp -d)"
      printf 'allowed\n' > "$allowedDir/readable"
      printf 'denied\n' > "$deniedDir/blocked"

      "$landlock" \
        --ro /nix/store \
        --rw /dev/null \
        --rw "$allowedDir" \
        -- \
        "${stdenv.shell}" \
        -c '
          printf "written\n" > "$1/writable"
          test "$(cat "$1/readable")" = allowed
          test "$(cat "$1/writable")" = written

          if cat "$2/blocked" > /dev/null 2>&1; then
            exit 1
          fi

          if : > "$2/created" 2> /dev/null; then
            exit 1
          fi
        ' \
        _ \
        "$allowedDir" \
        "$deniedDir"
    else
      probeStatus=$?
      test "$probeStatus" -eq 125
      grep -q '^landlock-run: ' "$landlockProbe"
    fi

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
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
