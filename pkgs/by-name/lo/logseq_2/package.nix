{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchPnpmDeps,
  writeShellScriptBin,

  cacert,
  clang_20,
  clojure,
  copyDesktopItems,
  darwin,
  git,
  makeDesktopItem,
  makeWrapper,
  nodejs-slim,
  pkg-config,
  pnpm_9,
  pnpmConfigHook,
  python3,
  removeReferencesTo,
  xcbuild,

  electron_42,
  libsecret,
}:

let
  electron = electron_42;
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logseq";
  version = "2.0.0-unstable-2026-06-12";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "logseq";
    rev = "80aeb07d1c0783578e234450e82414d7d3b4bb60";
    hash = "sha256-31eJEzpLVxPqZQ2fqSJUP8sp5RsJyllOiXj+6B14cUg=";
  };

  patches = [
    # disable app-managed logseq-cli installation
    ./logseq-cli-install.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-gnRGWsPAMky4e6Q7RpCOzpRdylMTf20e/dqBAsBNUiM=";
  };

  uiPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-ui";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd packages/ui";
    fetcherVersion = 3;
    hash = "sha256-hpAMu8cmm0DfVBKr+ThL7cpC3AXdOhEHeAjE5+pfFL8=";
  };

  resourcesPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-resources";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd resources";
    fetcherVersion = 3;
    hash = "sha256-skY2MNPcvfl+2AxD0KoZWPdemP5oj96CRD79W8TNkPg=";
  };

  clojureHome = stdenv.mkDerivation {
    name = "logseq-${finalAttrs.version}-clojure-home";
    inherit (finalAttrs) src patches;

    nativeBuildInputs = [
      cacert
      clojure
      git
    ];

    buildPhase = ''
      runHook preBuild

      mkdir -p "$out"
      export HOME="$out"
      export JAVA_TOOL_OPTIONS="-Duser.home=$out"

      # -P       -> resolve all normal deps
      # -M:alias -> resolve extra-deps of the listed aliases
      clojure -P -M:cljs

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # copied from buildMavenPackage
      # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
      find "$out/.m2/repository" -type f \( \
        -name \*.lastUpdated \
        -o -name resolver-status.properties \
        -o -name _remote.repositories \) \
        -delete

      # remove .git pointers to the bare repos in _repos
      find "$out/.gitlibs/libs" -type f -name .git -delete

      # keep only the bare repo config files so the clojure CLI doesn't want to fetch the repos again
      # but make them be empty for reproducibility
      find "$out/.gitlibs/_repos" -type f -name "config" -print0 | while read -d "" f; do
        rm -rf "$(dirname "$f")"
        mkdir "$(dirname "$f")"
        touch "$f"
      done

      # recreate .clojure with empty settings
      rm -r "$out/.clojure"
      mkdir -p "$out/.clojure/tools"
      echo "{}" > "$out/.clojure/deps.edn"
      echo "{}" > "$out/.clojure/tools/tools.edn"

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-CfeNntatIoDTCWlO532MXMzJvD2csgrN4kgJgOCIp5s=";
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs =
    let
      clojureWithHome = writeShellScriptBin "clojure" ''
        export HOME="${finalAttrs.clojureHome}"
        export JAVA_TOOL_OPTIONS="-Duser.home=${finalAttrs.clojureHome}"
        exec ${lib.getExe' clojure "clojure"} "$@"
      '';

      # the build process runs `git describe --long --always --dirty`
      fakeGit = writeShellScriptBin "git" ''
        echo "${finalAttrs.src.rev or finalAttrs.version}@nixpkgs"
      '';
    in
    [
      clojureWithHome
      copyDesktopItems
      fakeGit
      makeWrapper
      nodejs-slim
      nodejs-slim.npm
      pkg-config
      pnpm
      pnpmConfigHook
      python3
      removeReferencesTo
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      clang_20 # newer clang breaks node-addon-api on darwin
      darwin.autoSignDarwinBinariesHook
      xcbuild # seems to only be needed on x86_64-darwin
    ];

  buildInputs = [
    libsecret
  ];

  env.LOGSEQ_BUILD_TIME = "1970-01-01T00:00:00Z";

  postConfigure = ''
    pnpmDeps=$uiPnpmDeps pnpmRoot=packages/ui pnpmConfigHook
    pnpmDeps=$resourcesPnpmDeps pnpmRoot=resources pnpmConfigHook

    # disable running electron-builder during the build, we'll run it manually later
    substituteInPlace resources/package.json \
      --replace-fail '"electron-builder ' '"true || electron-builder '

    mkdir static
    mv resources/node_modules static/node_modules

    electron_dist="$(mktemp -d)"
    cp -r ${electron.dist}/. "$electron_dist"
    chmod -R u+w "$electron_dist"
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}
    pnpm --dir packages/ui run build:ui
    pnpm run release-electron

    pushd static

    pnpm exec electron-builder \
      --dir \
      --config electron-builder.yml \
      -c.electronDist="$electron_dist" \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 static/icons/logseq.png "$out/share/icons/hicolor/512x512/apps/logseq.png"

    mkdir -p $out/share/logseq
    cp -r static/dist/*-unpacked/{locales,resources{,.pak}} $out/share/logseq

    makeWrapper ${lib.getExe electron} $out/bin/logseq-app \
      --add-flag "$out/share/logseq/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    makeWrapper ${lib.getExe electron} $out/bin/logseq \
      --set ELECTRON_RUN_AS_NODE 1 \
      --add-flag "$out/share/logseq/resources/app.asar/js/logseq-cli.js"

    remove-references-to -t ${nodejs-slim} "$out/share/logseq/resources/app.asar"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r static/dist/mac*/Logseq.app "$out/Applications"

    makeWrapper "$out/Applications/Logseq.app/Contents/MacOS/Logseq" "$out/bin/logseq-app"

    makeWrapper "$out/Applications/Logseq.app/Contents/MacOS/Logseq" "$out/bin/logseq" \
      --set ELECTRON_RUN_AS_NODE 1 \
      --add-flag "$out/Applications/Logseq.app/Contents/Resources/app.asar/js/logseq-cli.js"

    remove-references-to -t ${nodejs-slim} "$out/Applications/Logseq.app/Contents/Resources/app.asar"
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Logseq";
      desktopName = "Logseq";
      exec = "logseq-app %U";
      terminal = false;
      icon = "logseq";
      startupWMClass = "Logseq";
      comment = "A privacy-first, open-source platform for knowledge management and collaboration.";
      mimeTypes = [ "x-scheme-handler/logseq" ];
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Privacy-first, open-source platform for knowledge management and collaboration";
    homepage = "https://github.com/logseq/logseq";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "logseq-app";
    platforms = electron.meta.platforms;
  };
})
