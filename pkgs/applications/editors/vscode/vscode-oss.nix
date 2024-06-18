{
  lib,
  stdenv,
  fetchFromGitHub,
  cacert,
  jq,
  krb5,
  libsecret,
  makeDesktopItem,
  makeWrapper,
  moreutils,
  nodejs_18,
  electron_28,
  nodePackages,
  pkg-config,
  python3,
  ripgrep,
  xorg,
  yarn,
  darwin,

  # Customize product.json, with some reasonable defaults
  product ? (import ./vscode-oss/product.nix { inherit lib; }),

  shortName ? "Code - OSS",
  longName ? "Code - OSS",
  executableName ? "code-oss",

  # Extension gallery to use in vscode. It is open-vsix registry by default.
  extensionsGallery ? {
    serviceUrl = "https://open-vsx.org/vscode/gallery";
    itemUrl = "https://open-vsx.org/vscode/item";
  },

  # Override product.json
  productOverrides ? { },
}:

let
  inherit (nodePackages) node-gyp;
  inherit (darwin) autoSignDarwinBinariesHook;

  common = import ./common.nix {
    inherit
      lib
      makeDesktopItem
      shortName
      longName
      executableName
      ;
  };

  inherit (common) desktopItem urlHandlerDesktopItem;

  nodejs = nodejs_18;

  electron = electron_28;

  yarn' = yarn.override { inherit nodejs; };

  # Give all platform related information in this lambda.
  vscodePlatforms =
    hostPlatform:
    let
      select = attrs: name: attrs.${name} or name;
    in
    {
      ms = rec {
        # Map Microsoft system names.
        os = select {
          Darwin = "darwin";
          Linux = "linux";
        } hostPlatform.uname.system;
        arch = select {
          x86_64 = "x64";
          aarch64 = "arm64";
        } hostPlatform.uname.processor;
        # The name, interpolate it in gulp build tasks
        name = "${os}-${arch}";
      };
    };

  platform = vscodePlatforms stdenv.hostPlatform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = executableName;
  version = "1.89.1";
  commit = "dc96b837cf6bb4af9cd736aa3af08cf8279f7685";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    rev = finalAttrs.version;
    sha256 = "sha256-z4VA1pv+RPAzUOH/yK6EB84h4DOFG5TcRH443N7EIL0=";
  };

  passthru.product =
    # Base
    product
    // {
      inherit (finalAttrs) version;
      inherit extensionsGallery;

      nameShort = shortName;
      nameLong = longName;
      applicationName = executableName;
    }
    # Extra overrides
    // productOverrides;

  yarnCache = stdenv.mkDerivation (
    let
      inherit (finalAttrs) pname version src;
    in
    {
      inherit src;
      name = "${pname}-${version}-yarn-cache";
      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      nativeBuildInputs = [ yarn ];
      buildPhase = ''
        export HOME=$PWD
        yarn config set yarn-offline-mirror $out
        find "$PWD" -name "yarn.lock" -printf "%h\n" | \
          xargs -I {}                                                          \
            yarn --cwd {}                                                      \
            --frozen-lockfile                                                  \
            --ignore-scripts                                                   \
            --ignore-platform                                                  \
            --ignore-engines                                                   \
            --no-progress                                                      \
            --non-interactive
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-7Qy0xMLcvmZ43EcNbsy7lko0nsXlbVYSMiq6aa4LuoQ=";
    }
  );

  outputs = [
    # Desktop version.
    "out"

    # Remote extension host, for vscode remote development
    "reh"

    # Web extension host, run extension host in CLI, client in browser
    "rehweb"
  ];

  nativeBuildInputs =
    [
      yarn'
      python3
      nodejs
      jq
      moreutils
      pkg-config
      makeWrapper
    ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ];

  buildInputs = [
    krb5
    libsecret
    xorg.libX11
    xorg.libxkbfile
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  patches = map (name: ./vscode-oss/patches/${name}) (
    builtins.attrNames (builtins.readDir ./vscode-oss/patches)
  );

  env = {
    # Disable NAPI_EXPERIMENTAL to allow to build with Node.js≥18.20.0.
    NIX_CFLAGS_COMPILE = "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT";

    # Commit version embeded in vscode
    BUILD_SOURCEVERSION = finalAttrs.commit;
  };

  postPatch = ''
    export HOME=$PWD
  '';

  configurePhase = ''
    runHook preConfigure

    # Generate product.json
    cp ${builtins.toFile "product.json" (builtins.toJSON finalAttrs.passthru.product)} product.json

    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${finalAttrs.yarnCache}"
    # set nodedir to prevent node-gyp from downloading headers
    # taken from https://nixos.org/manual/nixpkgs/stable/#javascript-tool-specific
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}
    # use updated node-gyp. fixes the following error on Darwin:
    # PermissionError: [Errno 1] Operation not permitted: '/usr/sbin/pkgutil'
    export npm_config_node_gyp=${node-gyp}/lib/node_modules/node-gyp/bin/node-gyp.js
    runHook postConfigure
  '';

  preBuild = ''
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
    export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
    export SKIP_SUBMODULE_DEPS=1
    export NODE_OPTIONS=--openssl-legacy-provider
  '';

  buildPhase =
    ''
      runHook preBuild

      # install dependencies
      yarn --offline                                                           \
           --ignore-scripts                                                    \
           --no-progress                                                       \
           --non-interactive                                                   \
           --frozen-lockfile

      # run yarn install everywhere, skipping postinstall so we can patch esbuild
      find . -path "*node_modules" -prune -o \
        -path "./*/*" -name "yarn.lock" -printf "%h\n" |                       \
          xargs -I {}                                                          \
            yarn --cwd {}                                                      \
                 --frozen-lockfile                                             \
                 --offline                                                     \
                 --ignore-scripts                                              \
                 --ignore-engines

      # patch shebangs of node_modules to allow binary packages to build
      patchShebangs .
      # put ripgrep binary into bin so postinstall does not try to download it
      find -path "*@vscode/ripgrep" -type d                                    \
        -execdir mkdir -p {}/bin \;                                            \
        -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
    ''
    + lib.optionalString stdenv.isDarwin ''
      # use prebuilt binary for @parcel/watcher, which requires macOS SDK 10.13+
      # (see issue #101229)
      pushd ./remote/node_modules/@parcel/watcher
      mkdir -p ./build/Release
      mv ./prebuilds/darwin-x64/node.napi.glibc.node ./build/Release/watcher.node
      jq "del(.scripts) | .gypfile = false" ./package.json | sponge ./package.json
      popd
    ''
    + ''
      npm rebuild --build-from-source
      npm rebuild --prefix remote/ --build-from-source
      # run postinstall scripts after patching
      find . -path "*node_modules" -prune -o \
        -path "./*/*" -name "yarn.lock" -printf "%h\n" | \
          xargs -I {} sh -c 'jq -e ".scripts.postinstall" {}/package.json >/dev/null && yarn --cwd {} postinstall --frozen-lockfile --offline || true'
      yarn --offline gulp core-ci
      yarn --offline gulp compile-extensions-build
      yarn --offline gulp compile-extension-media-build
      yarn --offline gulp vscode-reh-${platform.ms.name}-min-ci
      yarn --offline gulp vscode-reh-web-${platform.ms.name}-min-ci
      yarn --offline gulp vscode-${platform.ms.name}-min-ci
      runHook postBuild
    '';

  installPhase =
    let
      binName = if stdenv.isDarwin then "resources/app/bin/code" else "bin/code-oss";
    in
    ''
      runHook preInstall
      mkdir -p $out/lib $out/bin
      mv ../VSCode-${platform.ms.name} $out/lib/vscode
      mv -T ../vscode-reh-${platform.ms.name} $reh
      mv -T ../vscode-reh-web-${platform.ms.name} $rehweb

      ln -s ${nodejs}/bin/node $reh/
      ln -s ${nodejs}/bin/node $rehweb/
    ''
    + lib.optionalString stdenv.isLinux ''
      mkdir -p $out/share/applications
      ln -s ${desktopItem}/share/applications/${executableName}.desktop $out/share/applications/${executableName}.desktop
      ln -s ${urlHandlerDesktopItem}/share/applications/${executableName}-url-handler.desktop $out/share/applications/${executableName}-url-handler.desktop
      install -D $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/${executableName}.png
    ''
    + ''
      # Make a wrapper script, setting the electron path, and vscode path
      makeWrapper "$out/lib/vscode/${binName}" "$out/bin/code-oss"             \
        --set ELECTRON '${lib.getExe electron}'                                \
        --set VSCODE_PATH "$out/lib/vscode"
      runHook postInstall
    '';

  meta = common.meta // {
    homepage = "https://github.com/microsoft/vscode";
    maintainers = with lib.maintainers; [ inclyc ];
  };
})
