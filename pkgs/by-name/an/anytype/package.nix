{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  nodejs,
  node-gyp,
  python3,
  bun,
  pkg-config,
  anytype-heart,
  libsecret,
  electron,
  go,
  lsof,
  protobuf,
  makeDesktopItem,
  copyDesktopItems,
  writableTmpDirAsHomeHook,
  commandLineArgs ? "",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anytype";
  version = "0.56.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-ts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7e8wGrha3eiW1ou0vJa/njDna87wDOPzpk4fX6qj9qA=";
  };

  locales = fetchFromGitHub {
    owner = "anyproto";
    repo = "l10n-anytype-ts";
    rev = "c16beda3d1a931d3330b1f7cc99185f7bdcba2f5";
    hash = "sha256-ludb8WyECZW0PxnhR/znHS3uXQuk8KDIXHujha4YeA0=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

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
      # https://bun.com/docs/pm/cli/install#configuring-with-environment-variables

      # Bun always tries to use the fastest available installation method for the target platform. On macOS, that’s clonefile and on Linux, that’s hardlink.
      bun install \
        --backend=copyfile \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-i2GPGi7LgIy8y+//rR0H+vX+bc/v2NKd7xGLargd044=";
    outputHashMode = "recursive";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # used upstream for builds: https://github.com/anyproto/anytype-ts/blob/5d66657f764c0649410e37c9e9c06e3ff18487ee/.github/workflows/build.yml#L192.
    NODE_OPTIONS = "--max-old-space-size=8192";
  };

  nativeBuildInputs = [
    bun
    nodejs
    pkg-config
    go
    protobuf
    copyDesktopItems
    makeWrapper
    node-gyp
    stdenv.cc
    python3
  ];

  buildInputs = [
    libsecret
  ];

  patches = [
    ./0001-feat-update-Disable-auto-checking-for-updates-and-updating-manually.patch
    ./0002-remove-grpc-devtools.patch
    ./0003-remove-desktop-entry.patch
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Building keytar against electron's ABI
    # Trying to build in temp dir, will not work due to the keytar calling the node -p require('node-addon-api').include_dir
    # but building inside the node_modules/keytar will find the ../node-addon-api automatically
    chmod -R u+w node_modules/keytar node_modules/node-addon-api
    pushd node_modules/keytar
    HOME=$(mktemp -d) node-gyp rebuild --nodedir=${electron.headers}
    popd

    substituteInPlace scripts/generate-protos.sh \
      --replace-fail "/usr/bin/env" "${coreutils}/bin/env"

    substituteInPlace package.json \
      --replace-fail \
        '"build:nmh": "go build -o dist/nativeMessagingHost ./go/nativeMessagingHost.go"' \
        '"build:nmh": "go build -trimpath -ldflags=-buildid= -o dist/nativeMessagingHost ./go/nativeMessagingHost.go"'

    cp -r ${anytype-heart}/lib dist/
    cp -r ${anytype-heart}/bin/anytypeHelper dist/

    # Without this, build fails when trying to copy/write into that directory during the js bundle step
    chmod -R u+w dist/

    bash ./scripts/generate-protos.sh --from-dist

    bun run build

    for lang in ${finalAttrs.locales}/locales/*; do
      cp "$lang" "dist/lib/json/lang/$(basename $lang)"
    done

    # $HOME/.cache/go-build.
    export GOCACHE=$(mktemp -d)
    # Runs "go build -o dist/nativeMessagingHost ./go/nativeMessagingHost.go"
    bun run build:nmh

    runHook postBuild
  '';

  # remove unnecessary files
  preInstall = ''
    chmod u+w -R dist node_modules
    find dist node_modules -type f \( -name '*.ts' -o -name '*.map' \) -delete
    rm -f node_modules/keytar/build/{Makefile,binding.Makefile,config.gypi,keytar.target.mk}
    rm -rf node_modules/keytar/build/Release/{.deps,obj.target}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/anytype
    cp -r electron.js electron dist node_modules package.json $out/lib/anytype/

    for icon in $out/lib/anytype/electron/img/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/anytype.png"
    done

    cp LICENSE.md $out/share

    makeWrapper '${lib.getExe electron}' $out/bin/anytype \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags $out/lib/anytype/ \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    wrapProgram $out/lib/anytype/dist/nativeMessagingHost \
      --prefix PATH : ${lib.makeBinPath [ lsof ]}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "anytype";
      exec = "anytype %U";
      icon = "anytype";
      desktopName = "Anytype";
      comment = finalAttrs.meta.description;
      mimeTypes = [ "x-scheme-handler/anytype" ];
      categories = [
        "Utility"
        "Office"
        "Calendar"
        "ProjectManagement"
      ];
      startupWMClass = "anytype";
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "P2P note-taking tool";
    homepage = "https://anytype.io/";
    changelog = "https://github.com/anyproto/anytype-ts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "anytype";
    maintainers = with lib.maintainers; [
      autrimpo
      adda
      kira-bruneau
      xmnlz
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
