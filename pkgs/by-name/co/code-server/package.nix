{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  cacert,
  moreutils,
  jq,
  git,
  rsync,
  pkg-config,
  runCommand,
  python3,
  esbuild,
  nodejs_22,
  node-gyp,
  libsecret,
  libkrb5,
  libx11,
  libxkbfile,
  ripgrep,
  cctools,
  xcbuild,
  quilt,
  nixosTests,
  prefetch-npm-deps,
}:

let
  system = stdenv.hostPlatform.system;

  nodejs = nodejs_22;

  esbuild_0272 = esbuild.override {
    buildGoModule =
      args:
      buildGoModule (
        args
        // rec {
          version = "0.27.2";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-JbJB3F1NQlmA5d0rdsLm4RVD24OPdV4QXpxW8VWbESA=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };

  # replaces esbuild's download script with a binary from nixpkgs
  patchEsbuild = path: version: esbuildPkg: ''
    mkdir -p ${path}/node_modules/esbuild/bin
    jq "del(.scripts.postinstall)" ${path}/node_modules/esbuild/package.json | sponge ${path}/node_modules/esbuild/package.json
    sed -i 's/${version}/${esbuildPkg.version}/g' ${path}/node_modules/esbuild/lib/main.js
    ln -s -f ${esbuildPkg}/bin/esbuild ${path}/node_modules/esbuild/bin/esbuild
  '';

  # Comment from @code-asher, the code-server maintainer
  # See https://github.com/NixOS/nixpkgs/pull/240001#discussion_r1244303617
  #
  # If the commit is missing it will break display languages (Japanese, Spanish,
  # etc). For some reason VS Code has a hard dependency on the commit being set
  # for that functionality.
  # The commit is also used in cache busting. Without the commit you could run
  # into issues where the browser is loading old versions of assets from the
  # cache.
  # Lastly, it can be helpful for the commit to be accurate in bug reports
  # especially when they are built outside of our CI as sometimes the version
  # numbers can be unreliable (since they are arbitrarily provided).
  #
  # To compute the commit when upgrading this derivation, do:
  # `$ git rev-parse <git-rev>` where <git-rev> is the git revision of the `src`
  # Example: `$ git rev-parse v4.16.1`
  commit = "9184b645cc7aa41b750e2f2ef956f2896512dd84";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "code-server";
  version = "4.109.2";

  src = fetchFromGitHub {
    owner = "coder";
    repo = "code-server";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-AY99no2fU6by8KSvWsVxMPaLqbKIOWp72Pa+eGfGU7k=";
  };

  nodeModules =
    runCommand "code-server-node-modules"
      {
        inherit (finalAttrs) src nativeBuildInputs;
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-3buaQDcOBVZCBfdxEXqmQZKv0R+A1lLIc65HJul780Y=";
        env = {
          FORCE_EMPTY_CACHE = true;
          FORCE_GIT_DEPS = true;
          npm_config_progress = false;
          npm_config_cafile = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        };
      }
      ''
        runPhase unpackPhase
        export HOME=$TMPDIR/home
        mkdir $out
        for p in $(find -name package-lock.json)
        do (
          echo "Prefetching $p"
          ${prefetch-npm-deps}/bin/prefetch-npm-deps "$p" "$out/$(dirname $p)"
        )
        done
      '';

  nativeBuildInputs = [
    nodejs
    python3
    pkg-config
    makeWrapper
    git
    rsync
    jq
    moreutils
    quilt
  ];

  buildInputs = [
    libx11
    libxkbfile
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libsecret
    libkrb5
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  patches = [
    # Remove all git calls from the VS Code build script except `git rev-parse
    # HEAD` which is replaced in postPatch with the commit.
    ./build-vscode-nogit.patch
  ];

  postPatch = ''
    export HOME=$PWD

    patchShebangs ./ci

    # inject git commit
    substituteInPlace ./ci/build/build-vscode.sh \
      --replace-fail '$(git rev-parse HEAD)' "${commit}"
    substituteInPlace ./ci/build/build-release.sh \
      --replace-fail '$(git rev-parse HEAD)' "${commit}"

    substituteInPlace ./lib/vscode/build/npm/postinstall.ts \
      --replace-fail "child_process.execSync('git config pull.rebase merges');" \
        "try { child_process.execSync('git config pull.rebase merges'); } catch {}" \
      --replace-fail "child_process.execSync('git config blame.ignoreRevsFile .git-blame-ignore-revs');" \
        "try { child_process.execSync('git config blame.ignoreRevsFile .git-blame-ignore-revs'); } catch {}"
  '';

  env = {
    NODE_OPTIONS = "--openssl-legacy-provider --max-old-space-size=4096";
    NODE_ENV = "development";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NIX_NODEJS_BUILDNPMPACKAGE = "1";
    npm_config_nodedir = nodejs;
    npm_config_node_gyp = "${node-gyp}/lib/node_modules/node-gyp/bin/node-gyp.js";
    npm_config_offline = true;
    npm_config_progress = false;
    prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";
    forceGitDeps = true;
  };

  preConfigure = ''
    export HOME=$TMPDIR/home
    mkdir -p $HOME
    cp -R $nodeModules $TMPDIR/cache
    chmod -R +w $TMPDIR/cache
  '';

  configurePhase = ''
    runHook preConfigure

    for p in $(find -name package-lock.json -exec dirname {} \;)
    do (
      echo "Setting up $p/node_modules"
      cd $p
      if [ -e node_modules ]
      then
        echo >&2 "File exists $p/node_modules"
        exit 0
      fi
      npm_config_cache=$TMPDIR/cache/$p npm ci --ignore-scripts
      patchShebangs node_modules
    )
    done

    # set nodedir to prevent node-gyp from downloading headers
    # taken from https://nixos.org/manual/nixpkgs/stable/#javascript-tool-specific
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 11 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Apply patches.
    quilt push -a

    export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
    export SKIP_SUBMODULE_DEPS=1
    export NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=4096"

    # Remove all built-in extensions, as these are 3rd party extensions that
    # get downloaded from the VS Code marketplace.
    jq --slurp '.[0] * .[1]' "./lib/vscode/product.json" <(
      cat << EOF
    {
      "builtInExtensions": []
    }
    EOF
    ) | sponge ./lib/vscode/product.json

    # Disable automatic updates.
    sed -i '/update.mode/,/\}/{s/default:.*/default: "none",/g}' \
      lib/vscode/src/vs/platform/update/common/update.config.contribution.ts

    # Patch out remote download of nodejs from build script.
    patch -p1 -i ${./remove-node-download.patch}

    patchShebangs .

    # Use esbuild from nixpkgs.
    ${patchEsbuild "./lib/vscode/build" "0.27.2" esbuild_0272}
    ${patchEsbuild "./lib/vscode/extensions" "0.27.2" esbuild_0272}

    # Put ripgrep binary into bin, so post-install does not try to download it.
    find -name ripgrep -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;

    # Run post-install scripts after patching.
    find -name package.json -type f -exec sh -c '
      if jq -e ".scripts.postinstall" {} >-
      then
        echo >&2 "Running postinstall script in $(dirname {})"
        npm --prefix=$(dirname {}) run postinstall
      fi
      exit 0
    ' \;
    patchShebangs .

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Use prebuilt binary for @parcel/watcher, which requires macOS SDK 10.13+
    # (see issue #101229).
    pushd ./lib/vscode/remote/node_modules/@parcel/watcher
    mkdir -p ./build/Release
    mv ./prebuilds/darwin-x64/node.napi.glibc.node ./build/Release/watcher.node
    jq "del(.scripts) | .gypfile = false" ./package.json | sponge ./package.json
    popd
  ''
  + ''

    # Build binary packages (argon2, node-pty, etc).
    npm rebuild --offline
    npm rebuild --offline --prefix lib/vscode/remote

    # Build code-server and VS Code.
    npm run build
    VERSION=${finalAttrs.version} npm run build:vscode

    # Inject version into package.json.
    jq --slurp '.[0] * .[1]' ./package.json <(
      cat << EOF
    {
      "version": "${finalAttrs.version}"
    }
    EOF
    ) | sponge ./package.json

    # Create release, keeping all dependencies.
    KEEP_MODULES=1 npm run release

    # Prune development dependencies.  We only need to do this for the root as
    # the VS Code build process already does this for VS Code.
    npm prune --omit=dev --prefix release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/code-server $out/bin

    # copy release to libexec path
    cp -R -T release "$out/libexec/code-server"

    # create wrapper
    makeWrapper "${nodejs}/bin/node" "$out/bin/code-server" \
      --add-flags "$out/libexec/code-server/out/node/entry.js"

    runHook postInstall
  '';

  passthru = {
    prefetchNodeModules = lib.overrideDerivation finalAttrs.nodeModules (d: {
      outputHash = lib.fakeSha256;
    });
    tests = {
      inherit (nixosTests) code-server;
    };
    # vscode-with-extensions compatibility
    executableName = "code-server";
    longName = "Visual Studio Code Server";
  };

  meta = {
    changelog = "https://github.com/coder/code-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Run VS Code on a remote server";
    longDescription = ''
      code-server is VS Code running on a remote server, accessible through the
      browser.
    '';
    homepage = "https://github.com/coder/code-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      offline
      henkery
      code-asher
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ];
    mainProgram = "code-server";
  };
})
