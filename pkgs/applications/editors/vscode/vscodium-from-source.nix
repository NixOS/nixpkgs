{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cacert,
  jq,
  git,
  pkg-config,
  runCommand,
  zip,
  electron,
  nodejs,
  node-gyp-build,
  libsecret,
  libkrb5,
  libx11,
  libxkbfile,
  ripgrep,
  cctools,
  prefetch-npm-deps,
  parallel,
}:
let

  system = stdenv.hostPlatform.system;

  vsBuildArch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      aarch64-darwin = "arm64";
    }
    .${system} or (throw "Unsupported system ${system}");

  nodeBuildTarget = "${if stdenv.hostPlatform.isDarwin then "darwin" else "linux"}-${vsBuildArch}";

in
stdenv.mkDerivation (
  finalAttrs:
  let

    builtInExtensionVsix = lib.listToAttrs (
      map (ext: {
        name = ext.name;
        value = fetchurl {
          name = "${ext.name}-${ext.version}.vsix";
          url = "${ext.repo}/releases/download/v${ext.version}/${ext.name}.${ext.version}.vsix";
          hash = builtins.convertHash {
            hash = ext.sha256;
            hashAlgo = "sha256";
            toHashFormat = "sri";
          };
        };
      }) (lib.importJSON "${finalAttrs.vscodeSrc}/product.json").builtInExtensions
    );

    # The `vscode-*-packing` gulp task assembles the desktop app by merging the
    # compiled sources with an Electron distribution. @vscode/gulp-electron can
    # only ingest that distribution as a zip (it streams the entries through
    # gulp-vinyl-zip), so repackage the nixpkgs-provided Electron, instead of
    # downloading the upstream prebuilt. ELECTRON_SKIP_BINARY_DOWNLOAD only
    # covers the npm `electron` package and does not stop this path
    electronVersion = builtins.head (
      builtins.match ".*target=\"([0-9.]+)\".*" (
        builtins.replaceStrings [ "\n" ] [ " " ] (builtins.readFile "${finalAttrs.vscodeSrc}/.npmrc")
      )
    );
    electronPlatform = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
    electronArch =
      {
        x86_64-linux = "x64";
        aarch64-linux = "arm64";
        x86_64-darwin = "x64";
        aarch64-darwin = "arm64";
      }
      .${system} or (throw "Unsupported system ${system}");
    # We're accepting some version skew here. Assumption is, that nixpkgs will have
    # newer electron and that it will have remained compatible.
    electronFile = "electron-v${electronVersion}-${electronPlatform}-${electronArch}.zip";
    electronDist = electron.dist;
    electronZip =
      runCommand electronFile
        {
          nativeBuildInputs = [ zip ];
        }
        ''
          mkdir dist
          cp -r ${electronDist}/. dist/
          chmod -R u+w dist
          cd dist
          zip -r -q $out .
        '';
  in
  {
    pname = "vscodium";
    version = "1.143.17183";

    src = fetchFromGitHub {
      owner = "VSCodium";
      repo = "vscodium";
      rev = finalAttrs.version;
      hash = "sha256-wzOie7h/jwJL/dnM1z7k0cz7rSATVCQ6nsuPjcx1NWs=";
    };

    vscodeSrc = fetchFromGitHub {
      owner = "Microsoft";
      repo = "vscode";
      rev = (lib.importJSON "${finalAttrs.src}/upstream/stable.json").commit;
      hash = "sha256-GuR+613RHZ876yC1e1glj0TC+4syMDG0SV7IVKY7S+4=";
    };

    ## fetchNpmDeps doesn't correctly process git dependencies
    ## presumably because of https://github.com/npm/cli/issues/5170
    ## therefore, we're fetching all the node_module folders into
    ## a single FOD, and unpack it in configurePhase
    npmCache =
      runCommand "vscodium-npm-cache"
        {
          src = finalAttrs.vscodeSrc;
          vscodiumSrc = finalAttrs.src;
          inherit (finalAttrs) nativeBuildInputs;
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          # TODO: recompute for the per-lockfile cache directory layout.
          outputHash = "sha256-vCIYwl6Y3qEu0ng3vLy34wgmTrYVL+NdQnI97zd1nmQ=";
          env = {
            FORCE_EMPTY_CACHE = true;
            FORCE_GIT_DEPS = true;
            NODE_ENV = "development";
            npm_config_progress = false;
            npm_config_cafile = "${cacert}/etc/ssl/certs/ca-bundle.crt";
          };
        }
        (
          ''
            runPhase unpackPhase
            export HOME=$TMPDIR/home
            mkdir -p $HOME
            mkdir $out

            # First, prefetch the plain upstream lockfiles.
            for p in $(find -name package-lock.json)
            do (
              echo "Prefetching $p"
              ${prefetch-npm-deps}/bin/prefetch-npm-deps "$p" "$out/$(dirname $p)"
            )
            done
          ''
          # vscodium's prepare_vscode.sh rewrites several
          # package-lock.json files at build time. Prefetch those
          # patched lockfiles too. The second pass writes into the same
          # per-lockfile cache directories as the first, so both sets of
          # tarballs end up in the cache that the offline `npm ci` reads.
          # TODO: Currently, this is inefficient
          # and will download dependencies multiple times.
          # This will be solved by https://github.com/NixOS/nixpkgs/pull/545734
          + ''
            cp -R ${finalAttrs.src}/patches ./vscodium-patches
            cp -rp ${finalAttrs.src}/src/stable/. .
            cp -f ${finalAttrs.src}/LICENSE LICENSE.txt
            chmod -R u+w .
            export APP_NAME=VSCodium
            export APP_NAME_LC=vscodium
            export ASSETS_REPOSITORY=VSCodium/vscodium
            export BINARY_NAME=codium
            export GH_REPO_PATH=VSCodium/vscodium
            export ORG_NAME=VSCodium
            export GLOBAL_DIRNAME=vscodium
            export TUNNEL_APP_NAME=codium-tunnel
            export RELEASE_VERSION=${finalAttrs.version}
            export VSCODE_QUALITY=stable
            export OS_NAME=${if stdenv.hostPlatform.isDarwin then "osx" else "linux"}
            source ${finalAttrs.src}/utils.sh
            for f in ./vscodium-patches/*.json
            do
              [ -f "$f" ] && apply_actions "$f"
            done
            for f in ./vscodium-patches/*.patch
            do
              [ -f "$f" ] && apply_patch "$f"
            done
            if [ -d "./vscodium-patches/$OS_NAME" ]
            then
              for f in "./vscodium-patches/$OS_NAME"/*.patch
              do
                [ -f "$f" ] && apply_patch "$f"
              done
            fi
            for f in ./vscodium-patches/user/*.patch
            do
              [ -f "$f" ] && apply_patch "$f"
            done
            for p in $(find -name package-lock.json)
            do (
              echo "Prefetching patched $p"
              ${prefetch-npm-deps}/bin/prefetch-npm-deps "$p" "$out/$(dirname $p)"
            )
            done
          ''
        );

    env = {
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
      ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
      # ensure the correct node-gyp (from nixpkgs) is used
      NIX_NODEJS_BUILDNPMPACKAGE = "1";
      npm_config_node_gyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";
      # Compile native modules against the nodejs headers instead of letting
      # node-gyp download Electron/Node headers. All the addons here are
      # node-addon-api (N-API), so node headers are valid for the Electron app as well.
      npm_package_config_node_gyp_nodedir = nodejs;
      # The npmCache FOD pre-seeds the full offline cache.
      npm_config_offline = true;
      npm_config_progress = false;
      # For packages whose install scripts run
      #   $prefetchNpmDeps --fixup-lockfile package-lock.json || [ -n "$forceGitDeps" ]
      # during `npm ci`. Setting `prefetchNpmDeps` lets the fixup run for git deps,
      # and `forceGitDeps` makes the guard succeed even if it cannot (offline).
      prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";
      forceGitDeps = true;
    };

    nativeBuildInputs = [
      nodejs
      nodejs.python
      node-gyp-build
      pkg-config
      git
      jq
    ];

    buildInputs = [
      libx11
      libxkbfile
      libkrb5
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ];

    # akin to `. get-repo.sh`
    postUnpack = ''
      cp -R ${finalAttrs.vscodeSrc} $sourceRoot/vscode
      chmod -R +w $sourceRoot/vscode
    ''
    # We accept some version drift here:
    # build/gulpfile.reh.ts derives the server node version from
    # remote/.npmrc's `target=` and downloads a matching node.js into
    # .build/node/v<version>/<platform>-<arch>/ if it is missing.
    + ''
      sed -i 's|^target=.*|target="${nodejs.version}"|' $sourceRoot/vscode/remote/.npmrc
      mkdir -p $sourceRoot/vscode/.build/node/v${nodejs.version}/${nodeBuildTarget}
      ln -sf ${nodejs}/bin/node $sourceRoot/vscode/.build/node/v${nodejs.version}/${nodeBuildTarget}/node
    ''
    + ''
      patchShebangs $sourceRoot
    '';

    preConfigure = ''
      export HOME=$TMPDIR/home
      mkdir -p $HOME
      mkdir -p $TMPDIR
      cp -R $npmCache $TMPDIR/cache
      chmod -R +w $TMPDIR/cache
      export npm_config_cache=$TMPDIR/cache
    ''
    # Vendor the GitHub-only built-in extensions (ms-vscode.js-debug and
    # friends) and add their `vsix` paths to product.json
    + ''
      mkdir -p vscode/.build/vsix
      cp ${builtInExtensionVsix."ms-vscode.js-debug"} vscode/.build/vsix/ms-vscode.js-debug.vsix
      cp ${
        builtInExtensionVsix."ms-vscode.js-debug-companion"
      } vscode/.build/vsix/ms-vscode.js-debug-companion.vsix
      cp ${
        builtInExtensionVsix."ms-vscode.vscode-js-profile-table"
      } vscode/.build/vsix/ms-vscode.vscode-js-profile-table.vsix
      jq --argjson vsix '{"ms-vscode.js-debug":".build/vsix/ms-vscode.js-debug.vsix","ms-vscode.js-debug-companion":".build/vsix/ms-vscode.js-debug-companion.vsix","ms-vscode.vscode-js-profile-table":".build/vsix/ms-vscode.vscode-js-profile-table.vsix"}' \
        '.builtInExtensions |= map(if $vsix[.name] then .vsix = $vsix[.name] else . end)' \
        vscode/product.json > vscode/product.json.tmp
      mv vscode/product.json.tmp vscode/product.json
    ''
    + ''
      substituteInPlace vscode/build/npm/preinstall.ts \
        --replace-fail 'installHeaders();' '/* installHeaders() skipped: headers pre-seeded offline */'
    ''
    # --- Hook into the VSCodium build system instead of editing it -----------
    # build.sh sources prepare_vscode.sh from the VSCodium root and only then
    # runs the gulp tasks.
    # Installing straight from the lockfile is what the configurePhase
    # pass already does, so ignore scripts here.
    + ''
      mv prepare_vscode.sh prepare_vscode.upstream.sh
      cat > prepare_vscode.sh <<'VSCODIUM_PREPARE_WRAPPER'
      #!/usr/bin/env bash
      # nix wrapper around the pristine upstream prepare_vscode.sh.
      vscodium_root=$PWD
      export npm_config_ignore_scripts=true
      . ./prepare_vscode.upstream.sh
      unset npm_config_ignore_scripts
      cd "$vscodium_root"
      unset vscodium_root
      patchShebangs vscode/node_modules
      mkdir -p vscode/node_modules/.bin
      cat > vscode/node_modules/.bin/node-gyp <<'VSCODIUM_NODE_GYP_SHIM'
      #!/bin/sh
      exec ${nodejs}/bin/node ${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js "$@"
      VSCODIUM_NODE_GYP_SHIM
      chmod +x vscode/node_modules/.bin/node-gyp
      ln -sf ${node-gyp-build}/bin/node-gyp-build vscode/node_modules/.bin/node-gyp-build
      ln -sf ${node-gyp-build}/bin/node-gyp-build-optional vscode/node_modules/.bin/node-gyp-build-optional
      ln -sf ${node-gyp-build}/bin/node-gyp-build-test vscode/node_modules/.bin/node-gyp-build-test
      native=$(cd vscode && find node_modules -maxdepth 3 -name binding.gyp \
        -not -path '*/node_modules/*/node_modules/*' 2>/dev/null \
        | sed -e 's|^node_modules/||' -e 's|/binding\.gyp$||')
      if [ -n "$native" ]; then
        echo "Rebuilding native addons in vscode/: $native"
        npm --prefix vscode rebuild --build-from-source $native
      else
        echo "warning: no binding.gyp addons found to rebuild" >&2
      fi
      VSCODIUM_PREPARE_WRAPPER
    ''
    # Serve the repackaged nixpkgs Electron zip to @vscode/gulp-electron through
    # its `repo` option, which is gulp-electron's custom-downloader hook
    + ''
      electronSha256=$(sha256sum ${electronZip} | cut -d' ' -f1)
      export VSCODIUM_ELECTRON_ZIP=${electronZip}
      export VSCODIUM_ELECTRON_SHASUMS="$electronSha256 *${electronFile}"
    ''
    # gulp-electron validates the extracted artifact against
    # vscode/build/checksums/electron.txt. Replace that entry with the
    # hash of our repackaged Electron.
    + ''
      sed -i -E "s|^[0-9a-f]{64} \*${electronFile}$|$electronSha256 *${electronFile}|" \
        vscode/build/checksums/electron.txt
    ''
    # Point that hook at the store copy (`repo` is only consulted for the
    # Electron distribution; VSCodium's own gulp tasks are untouched).
    # @electron/get validates the artifact against the resolver
    + ''
      substituteInPlace vscode/build/lib/electron.ts \
        --replace-fail 'repo: electronAssetResolver,' \
                       'repo: nixElectronAssetResolver,'
      cat >> vscode/build/lib/electron.ts <<'VSCODIUM_EOF'

      async function nixElectronAssetResolver(opts: { url: string; fileName: string }): Promise<Response> {
        const zip = process.env['VSCODIUM_ELECTRON_ZIP']!;
        if (opts.fileName === 'SHASUMS256.txt') {
          return new Response(process.env['VSCODIUM_ELECTRON_SHASUMS']!);
        }
        const size = (await fs.promises.stat(zip)).size;
        const body = Readable.toWeb(fs.createReadStream(zip)) as ReadableStream<Uint8Array>;
        return new Response(body, { status: 200, headers: { 'Content-Length': String(size) } });
      }
      VSCODIUM_EOF
    ''
    # Since we're running with external electron, add --app to its launch
    + ''
      substituteInPlace vscode/src/vs/code/node/cli.ts \
        --replace-fail 'child = spawn(process.execPath, spawnArgs, options);' \
                       'spawnArgs.unshift("--app=" + getAppRoot()); child = spawn(process.execPath, spawnArgs, options);'
      substituteInPlace vscode/src/vs/platform/environment/node/argvHelper.ts \
        --replace-fail 'let [, ...args] = processArgv;' \
                       'let [, ...args] = processArgv; args = args.filter(arg => !arg.startsWith("--app="));'
    '';

    configurePhase = ''
      runHook preConfigure
    ''
    # unpack all of the prefetched node_modules folders
    + ''
      ( cd vscode
    ''
    # but exclude unused / undesirable dependencies this seems
    # to line up with missing `resolved`/`integrity` entries
    + ''
      for p in $(find -name package-lock.json -not -path '*/extensions/copilot/*' -not -path '*/build/rspack/*' -not -path './build/package-lock.json' -exec dirname {} \;)
      do (
        echo "Setting up $p/node_modules"
        cd $p
        if [ -e node_modules ]
        then
          echo >&2 "File exists $p/node_modules"
          exit 0
        fi
        npm ci --ignore-scripts --cache $TMPDIR/cache/$p
        if [ -e node_modules ]
        then
          patchShebangs node_modules
        else
          echo >&2 "No $p/node_modules, skipping patchShebangs"
        fi
      )
      done
    ''
    # build/ has its own lockfile and is patched to use @vscodium/vsce by
    # prepare_vscode.sh in buildPhase. The generic loop above skips it, and
    # npmCache only prefetches tarballs. Apply the two file hunks from
    # 00-vsce-use-custom-lib.patch early so npm ci installs the right package,
    # then restore the files for prepare_vscode.sh.
    + ''
      (
        cp build/package.json build/package.json.vscodium-bak
        cp build/package-lock.json build/package-lock.json.vscodium-bak
        git apply --ignore-whitespace \
          --include='build/package.json' \
          --include='build/package-lock.json' \
          ../patches/00-vsce-use-custom-lib.patch
        ( cd build && npm ci --ignore-scripts --cache $TMPDIR/cache/build )
        if [ -e build/node_modules ]
        then
          patchShebangs build/node_modules
        fi
        mv -f build/package.json.vscodium-bak build/package.json
        mv -f build/package-lock.json.vscodium-bak build/package-lock.json
      )
      )
    ''
    ## put ripgrep binary into bin so postinstall does not try to download it
    + ''
      find -path "*@vscode/ripgrep" -type d \
        -execdir mkdir -p {}/bin \; \
        -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
    ''
    ## node-pty build fix
    + ''
      find -path vscode/node_modules/node-pty/scripts/gen-compile-commands.js \
           -exec substituteInPlace {} \
                   --replace-fail "npx node-gyp" "$npm_config_node_gyp" \
                 \;
    ''
    ## run postinstall scripts
    + ''
      find vscode -name package.json -type f | ${parallel}/bin/parallel --will-cite --line-buffer '
        if jq -e ".scripts.postinstall" {} >-
        then
          echo >&2 "Running postinstall script in $(dirname {})"
          npm --prefix=$(dirname {}) run postinstall
        fi
        exit 0
      '
    ''
    # Rebuild the remote tree's native modules from source. The `npm ci`
    # above used --ignore-scripts, so binding.gyp-only packages
    # (e.g. @vscode/spdlog) have no .node yet. The remote tree targets
    # node (remote/.npmrc). The desktop tree is rebuilt in
    # prepare_vscode.sh instead, because its node_modules is re-created
    # there.
    + ''
      echo >&2 "Rebuilding native modules in vscode/remote"
      npm --prefix vscode/remote rebuild --build-from-source
    ''
    + ''
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      export SHOULD_BUILD="yes"
    ''
    # the REH (headless remote) build needs a separate `remote` rebuild that is
    # currently not wired up here; it is not required for the desktop + web
    # editions, so skip it for now.
    + ''
      export SHOULD_BUILD_REH="no"
      export SHOULD_BUILD_REH_WEB="yes"
    ''
    # build_cli.sh builds the Rust tunnel CLI (bin/codium-tunnel).
    # It is not guarded by anything except SHOULD_BUILD_CLI (which only
    # VSCodium's CI sets), and it reaches the network twice: it runs a bare
    # `npm pack @vscode/openssl-prebuilt@0.0.11` (not in any lockfile, so the
    # npmCache FOD has no copy) and then builds with rustup/cargo against
    # crates.io. Neither is available offline, and the desktop app does not
    # need it to launch: bin/codium is resources/linux/bin/code.sh driving
    # out/cli.js. Skip it; wire the Rust CLI up separately if tunnels are
    # wanted.
    + ''
      export SHOULD_BUILD_CLI="no"
      export CI_BUILD="no"
      export OS_NAME="${if stdenv.hostPlatform.isDarwin then "osx" else "linux"}"
      export VSCODE_ARCH="${vsBuildArch}"
      export VSCODE_QUALITY="stable"
      export RELEASE_VERSION="${finalAttrs.version}"
      . build.sh
      runHook postBuild
    '';

    outputs = [
      "out"
      "web"
    ];

    installPhase = ''
      runHook preInstall
    ''
    # Desktop build. gulp-electron merges the compiled sources with an
    # Electron distribution; ship only the app payload and drop that
    # runtime, because the app is started with the nixpkgs electron package
    + ''
      mkdir -p "$out/share/vscodium"
      cp -R -T "VSCode-linux-${vsBuildArch}/resources" "$out/share/vscodium/resources"
      mkdir -p "$out/bin"
      cat > "$out/bin/codium" <<'VSCODIUM_EOF'
      #!/bin/sh
    ''
    # ELECTRON_RUN_AS_NODE runs Electron as plain node, so the CLI (out/cli.js)
    # can parse the arguments and then re-exec Electron for the GUI (cli.ts
    # passes an explicit --app=, since the runtime is not next to the app).
    + ''
      export ELECTRON_RUN_AS_NODE=1
      exec ${electron}/bin/electron "${placeholder "out"}/share/vscodium/resources/app/out/cli.js" "$@"
      VSCODIUM_EOF
      chmod +x "$out/bin/codium"
      patchShebangs "$out/bin"
      mkdir -p "$web"
      cp -R -T "vscode-reh-web-linux-${vsBuildArch}" "$web"
      ln -sf "${nodejs}/bin/node" "$web/node"
      runHook postInstall
    '';

    passthru = {
      inherit electron;
    };

    meta = {
      description = "Open source build of VS Code, built from source (desktop and web editions)";
      longDescription = ''
        VSCodium is an open source build of Microsoft's VS Code editor, without
        the Microsoft branding, telemetry and licensing. This package is built
        from source and provides both the desktop (Electron) application and the
        web/remote server build.
      '';
      homepage = "https://github.com/VSCodium/vscodium";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        bendlas
      ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      mainProgram = "codium";
    };
  }
)
