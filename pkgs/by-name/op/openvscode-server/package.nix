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
  pkg-config,
  runCommand,
  nodejs_22,
  node-gyp,
  libsecret,
  libkrb5,
  libx11,
  libxkbfile,
  ripgrep,
  cctools,
  nixosTests,
  prefetch-npm-deps,
}:
let

  nodejs = nodejs_22;

  system = stdenv.hostPlatform.system;

  vsBuildTarget =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "darwin-x64";
      aarch64-darwin = "darwin-arm64";
    }
    .${system} or (throw "Unsupported system ${system}");

in
stdenv.mkDerivation (finalAttrs: {
  pname = "openvscode-server";
  version = "1.106.3";

  src = fetchFromGitHub {
    owner = "gitpod-io";
    repo = "openvscode-server";
    rev = "openvscode-server-v${finalAttrs.version}";
    hash = "sha256-wcmk35oqJ6d5MR9YnqC/pR0pC03/vCFCd9KLRByQWqk=";
  };

  ## fetchNpmDeps doesn't correctly process git dependencies
  ## presumably because of https://github.com/npm/cli/issues/5170
  ## therefore, we're fetching all the node_module folders into
  ## a single FOD, and unpack it in configurePhase
  nodeModules =
    runCommand "openvscode-server-node-modules"
      {
        inherit (finalAttrs) src nativeBuildInputs;
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-FnlzXlhu72G9dUnezzc62qH2TG5mU9EJNe9akWtR6zg=";
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

  env = {
    NODE_OPTIONS = "--openssl-legacy-provider";
    NODE_ENV = "development";

    # skip unnecessary binary downloads
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # ensure the correct node-gyp (from nixpkgs) is used
    NIX_NODEJS_BUILDNPMPACKAGE = "1";
    npm_config_nodedir = nodejs;
    npm_config_node_gyp = "${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js";
    npm_config_offline = true;
    npm_config_progress = false;

    # for --fixup-lockfile
    prefetchNpmDeps = "${prefetch-npm-deps}/bin/prefetch-npm-deps";
    forceGitDeps = true;

  };
  nativeBuildInputs = [
    nodejs
    nodejs.python
    pkg-config
    makeWrapper
    git
    jq
    moreutils
  ];

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ]
    ++ [
      libx11
      libxkbfile
      libkrb5
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ];

  # remove all built-in extensions, as these are 3rd party extensions that
  # get downloaded from vscode marketplace
  postPatch = ''
    jq --slurp '.[0] * .[1]' "product.json" <(
      cat << EOF
    {
      "builtInExtensions": []
    }
    EOF
    ) | sponge product.json
    echo "Updated product.json"
  ''
  ## build/lib/node.ts picks up nodejs version from remote/.npmrc
  ## and prefetches it into .build/node/v{version}/{target}/node
  ## so we pre-seed it here
  + ''
    sed -i 's/target=.*/target="${nodejs.version}"/' remote/.npmrc
    mkdir -p .build/node/v${nodejs.version}/${vsBuildTarget}
    ln -s ${nodejs}/bin/node .build/node/v${nodejs.version}/${vsBuildTarget}/node
  '';

  preConfigure = ''
    export HOME=$TMPDIR/home
    mkdir -p $HOME
    mkdir -p $TMPDIR
    cp -R $nodeModules $TMPDIR/cache
    chmod -R +w $TMPDIR/cache
  '';

  configurePhase = ''
    runHook preConfigure
  ''
  ## unpack all of the prefetched node_modules folders
  + ''
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
  ''
  ## put ripgrep binary into bin so postinstall does not try to download it
  + ''
    find -path "*@vscode/ripgrep" -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
  ''
  ## pre-seed node-gyp
  + ''
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 11 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
  ''
  ## node-pty build fix
  + ''
    find -path node_modules/node-pty/scripts/gen-compile-commands.js \
         -exec substituteInPlace {} \
                 --replace-fail "npx node-gyp" "$npm_config_node_gyp" \
               \;
  ''
  ## run postinstall scripts
  + ''
    find -name package.json -type f -exec sh -c '
      if jq -e ".scripts.postinstall" {} >-
      then
        echo >&2 "Running postinstall script in $(dirname {})"
        npm --prefix=$(dirname {}) run postinstall
      fi
      exit 0
    ' \;
  ''
  ## rebuild native binaries
  + ''
    echo >&2 "Rebuilding from source in ./remote"
    npm --prefix ./remote rebuild --build-from-source
  ''
  + ''
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    npm run gulp vscode-reh-web-${vsBuildTarget}-min

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R -T ../vscode-reh-web-${vsBuildTarget} $out
    ln -sf ${nodejs}/bin/node $out

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) openvscode-server;
  };

  meta = {
    description = "Run VS Code on a remote machine";
    longDescription = ''
      Run upstream VS Code on a remote machine with access through a modern web
      browser from any device, anywhere.
    '';
    homepage = "https://github.com/gitpod-io/openvscode-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dguenther
      ghuntley
      emilytrau
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "openvscode-server";
  };
})
