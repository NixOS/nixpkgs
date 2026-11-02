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

  electron_43,
  libsecret,
}:

let
  electron = electron_43;
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "logseq";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "logseq";
    tag = finalAttrs.version;
    hash = "sha256-rsVjF5LywZoQda9w6mobfnOdbZWo56inz/27jNzUTmo=";
  };

  patches = [
    # disable app-managed logseq-cli installation
    ./logseq-cli-install.patch

    # make node-abi recognize electron versions above 42
    ./bump-node-abi.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-xdEEk5N/G0wGHBYvFLe8N2EL66DYUpVpCSHkvvbsIuE=";
  };

  cliPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-cli";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd cli";
    pnpmInstallFlags = [ "--ignore-workspace" ];
    fetcherVersion = 3;
    hash = "sha256-EWSyhc/6oJGMqz1vcfspJiOuQSzqTRS3Oyy/Fpg7Jrk=";
  };

  resourcesPnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-resources";
    inherit (finalAttrs) src patches;
    inherit pnpm;
    postPatch = "cd resources";
    pnpmInstallFlags = [ "--ignore-workspace" ];
    fetcherVersion = 3;
    hash = "sha256-qSpEC2gTLn785MbJIfqJhtVjN4PObhbk9UxGJDw1wjs=";
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

    outputHash = "sha256-Iv/NFCmpMtkUHSlFAKGdZ4OHzQMMsOM7jTivYSTHgMQ=";
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
    pnpm run release-electron

    pushd static

    # ensure electron-builder thinks workspaceRoot=static
    # TODO: figure out a better solution
    touch pnpm-workspace.yaml

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
      --add-flag "$out/share/logseq/resources/app.asar/logseq-cli.js"

    remove-references-to -t ${nodejs-slim} "$out/share/logseq/resources/app.asar"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r static/dist/mac*/Logseq.app "$out/Applications"

    makeWrapper "$out/Applications/Logseq.app/Contents/MacOS/Logseq" "$out/bin/logseq-app"

    makeWrapper "$out/Applications/Logseq.app/Contents/MacOS/Logseq" "$out/bin/logseq" \
      --set ELECTRON_RUN_AS_NODE 1 \
      --add-flag "$out/Applications/Logseq.app/Contents/Resources/app.asar/logseq-cli.js"

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
      version = "0.5.0-unstable-2026-08-06";
      src = fetchFromGitHub {
        owner = "logseq";
        repo = "melange-edn";
        rev = "3cb79f278e972388a0a2b2ea1caec7a008a0b956";
        hash = "sha256-mdkjo4csQrQw0uTYaQ2gjlGp2kHSjN3PL4ljFDDTwQ8=";
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
      version = "0.1.0-unstable-2026-09-23";
      src = fetchFromGitHub {
        owner = "logseq";
        repo = "melange-transit";
        rev = "38ca92e299cf34c897d9a44091fe86e55b1315ee";
        hash = "sha256-zF5cku6WcBA/tfh0oJ1469ekyI3ObrBsGY/4b0WLXNI=";
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
        owner = "logseq";
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
