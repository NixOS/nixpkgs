{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchPnpmDeps,
  writeShellScriptBin,

  dune,
  ocamlPackages,

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
  pnpm_10,
  pnpmConfigHook,
  python3,
  removeReferencesTo,
  xcbuild,

  electron_42,
  libsecret,
}:

let
  electron = electron_42;
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logseq";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "logseq";
    tag = finalAttrs.version;
    hash = "sha256-egierIhPRm3J8NL1gAcAMvynzFTzoSzpeGN6m0aOSSI=";
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
    hash = "sha256-vkR6AbgdYA3GFZ54/CtcWwMIx9LBTMaadEpzMn9vgiQ=";
  };

  uiPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-ui";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd packages/ui";
    fetcherVersion = 3;
    hash = "sha256-g6W7Gsj4EF8D5dAbckD9d9kPJnA3cO/p936gy3A228g=";
  };

  cliPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-cli";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd cli";
    pnpmInstallFlags = [ "--ignore-workspace" ];
    fetcherVersion = 3;
    hash = "sha256-i5zJ+lvhcBF1CA1hFY4SlEg4p6IEfFrNPYTEYiFviiE=";
  };

  resourcesPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-resources";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd resources";
    pnpmInstallFlags = [ "--ignore-workspace" ];
    fetcherVersion = 3;
    hash = "sha256-URY5YPQCh2ariqOtaa97IiL2iObrvkDh5wEuFgLqRRI=";
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
        echo "${finalAttrs.version}@nixpkgs"
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

      dune
      ocamlPackages.findlib
      ocamlPackages.melange
      ocamlPackages.ocaml
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      clang_20 # newer clang breaks node-addon-api on darwin
      darwin.autoSignDarwinBinariesHook
      xcbuild # seems to only be needed on x86_64-darwin
    ];

  buildInputs = [
    libsecret

    ocamlPackages.melange
    finalAttrs.passthru.humanize
    finalAttrs.passthru.melange-edn-melange
    finalAttrs.passthru.melange-transit-melange
    finalAttrs.passthru.melange-fetch
    finalAttrs.passthru.rrbvec
  ];

  env.LOGSEQ_BUILD_TIME = "1970-01-01T00:00:00Z";

  postConfigure = ''
    pnpmDeps=$uiPnpmDeps pnpmRoot=packages/ui pnpmConfigHook
    pnpmDeps=$cliPnpmDeps pnpmRoot=cli pnpmInstallFlags="--ignore-workspace" pnpmConfigHook
    pnpmDeps=$resourcesPnpmDeps pnpmRoot=resources pnpmInstallFlags="--ignore-workspace" pnpmConfigHook

    # run dune directly instead of through opam
    substituteInPlace cli/package.json \
      --replace-fail 'opam exec -- dune' 'dune'

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

  passthru = {
    humanize = ocamlPackages.buildDunePackage {
      pname = "humanize";
      version = "0-unstable-2026-06-06";
      src = fetchFromGitHub {
        owner = "RCmerci";
        repo = "humanize";
        rev = "747879af704dff4dd1897bc0f9a53a361071371c";
        hash = "sha256-NalrZxGlcMAIAjX6x7fFLJFZKEcr8E3R83iM87TfyyE=";
      };
      nativeBuildInputs = [ ocamlPackages.melange ];
    };
    melange-edn-melange = ocamlPackages.buildDunePackage {
      pname = "melange-edn-melange";
      version = "0.5.0-unstable-2026-07-21";
      src = fetchFromGitHub {
        owner = "RCmerci";
        repo = "melange-edn";
        rev = "638b614d35d918a370643b43780c8e23ede96b41";
        hash = "sha256-EUFORQk4GwqHBCBCwPrfhkNqBVlUyTjR+eymAgA9BeM=";
      };
      nativeBuildInputs = [ ocamlPackages.melange ];
      propagatedBuildInputs = [ ocamlPackages.melange ];
    };
    melange-fetch = ocamlPackages.buildDunePackage {
      pname = "melange-fetch";
      version = "0.2.0";
      src = fetchFromGitHub {
        owner = "melange-community";
        repo = "melange-fetch";
        tag = "0.2.0";
        hash = "sha256-B0D2SMwUMR64S0SQADZ7CHE+z7tUq9GW5yuzBhLwkzA=";
      };
      nativeBuildInputs = [ ocamlPackages.melange ];
      propagatedBuildInputs = [ ocamlPackages.melange ];
    };
    melange-transit-melange = ocamlPackages.buildDunePackage {
      pname = "melange-transit-melange";
      version = "0.1.0-unstable-2026-06-28";
      src = fetchFromGitHub {
        owner = "RCmerci";
        repo = "melange-transit";
        rev = "99fb9f1c5bebf4ba5fa6d2378cfc97dbf14b5378";
        hash = "sha256-RFUbOSFKR8VEqwpm70Aii5Qh4qq2eO7yt4WXW+z3rlc=";
      };
      nativeBuildInputs = [ ocamlPackages.melange ];
      propagatedBuildInputs = [
        ocamlPackages.melange
        finalAttrs.passthru.melange-edn-melange
      ];
    };
    rrbvec = ocamlPackages.buildDunePackage {
      pname = "rrbvec";
      version = "0-unstable-2026-07-12";
      src = fetchFromGitHub {
        owner = "RCmerci";
        repo = "rrbvec";
        rev = "dd5ce904f91d53235b5136f7a771f3f074c3971d";
        hash = "sha256-zYT7cMMWJivVSB6H/vUDnaajvUOYddh0MF2Zu/wIGq0=";
      };
      nativeBuildInputs = [ ocamlPackages.melange ];
    };
  };

  meta = {
    description = "Privacy-first, open-source platform for knowledge management and collaboration";
    homepage = "https://github.com/logseq/logseq";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "logseq-app";
    platforms = electron.meta.platforms;
  };
})
