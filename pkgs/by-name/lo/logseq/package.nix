{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchPnpmDeps,
  replaceVars,
  writeShellScriptBin,

  cacert,
  clang_20,
  clojure,
  copyDesktopItems,
  darwin,
  git,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  pkg-config,
  pnpm_9,
  pnpmConfigHook,
  python3,
  removeReferencesTo,
  xcbuild,

  electron_39,
  libsecret,
}:

let
  electron = electron_39;
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logseq";
  version = "0.10.15-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "logseq";
    rev = "8b20877f7f79b30eef0452e9a0a27c46bc98a9a5";
    hash = "sha256-8t0BUA2ThMZ/jZO9GOCF1GrB5jxxihnufT8tYmaefx8=";
  };

  patches = [
    # fix electron compile scripts, set electron-dist, skip signing on mac
    # disable app-managed logseq-cli installation
    (replaceVars ./electron.patch {
      electron_version = electron.version;
    })
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src patches;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-N71LilA6xsKhND5GxCDsWAIJM3EeHjhaGmmaM4f1IYw=";
  };

  uiPnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src patches;
    inherit pnpm;
    postPatch = "cd packages/ui";
    fetcherVersion = 3;
    hash = "sha256-cOlyUP00IZ36/aUt2ovaCqmg5lWUfXg3w7cwwoqVfyg=";
  };

  resourcesPnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src patches;
    inherit pnpm;
    postPatch = "cd resources";
    fetcherVersion = 3;
    hash = "sha256-C3oPeV0TVcPJWWzpkilGOZF8XZWIY00zIfnSD82ESuE=";
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

      # copy the tree layout of _repos, but only keep the /config files of the bare repos
      # to trick the clojure CLI into thinking it doesn't need to fetch the repos again
      mkdir -p "$out/.gitlibs/_repos" "$out/.gitlibs/_new_repos"
      find "$out/.gitlibs/_repos" -type f -name "config" -print0 | while read -d "" f; do
        echo "$f"
        f=''${f/_repos/_new_repos}
        mkdir -p "$(dirname "$f")"
        touch "$f"
      done
      rm -rf "$out/.gitlibs/_repos"
      mv "$out/.gitlibs/_new_repos" "$out/.gitlibs/_repos"

      # recreate with empty settings
      rm -r "$out/.clojure"
      mkdir -p "$out/.clojure/tools"
      echo '{}' > $out/.clojure/deps.edn
      echo '{}' > $out/.clojure/tools/tools.edn

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-T5nRGhHWmVa6lEy2XdVzyBcNGQkvwuShwMJV2IgIZQs=";
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
  };

  strictDeps = true;

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
      nodejs
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

  postConfigure = ''
    pnpmDeps=$uiPnpmDeps pnpmRoot=packages/ui pnpmConfigHook
    pnpmDeps=$resourcesPnpmDeps pnpmRoot=resources pnpmConfigHook

    mkdir static
    mv resources/node_modules static/node_modules

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}
    pnpm --dir packages/ui run build:ui
    pnpm run release-electron

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

    remove-references-to -t ${nodejs} "$out/share/logseq/resources/app.asar"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r static/dist/mac*/Logseq.app "$out/Applications"

    makeWrapper "$out/Applications/Logseq.app/Contents/MacOS/Logseq" "$out/bin/logseq-app"

    makeWrapper "$out/Applications/Logseq.app/Contents/MacOS/Logseq" "$out/bin/logseq" \
      --set ELECTRON_RUN_AS_NODE 1 \
      --add-flag "$out/Applications/Logseq.app/Contents/Resources/app.asar/js/logseq-cli.js"

    remove-references-to -t ${nodejs} "$out/Applications/Logseq.app/Contents/Resources/app.asar"
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
