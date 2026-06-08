{
  lib,
  stdenv,

  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  electron,
  chromium,
  cacert,
  clojure,
  git,
  vips,

  writeShellScriptBin,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,

  nixosTests,
}:
buildNpmPackage (finalAttrs: {
  pname = "repath-studio";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "repath-studio";
    repo = "repath-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fnu7tZ8chvnDMuMw4QD1NuQgaFOBzHfzl2ePQ5iwnao=";
  };

  patches = [
    # outputHash of clojureHome changes each time `clojure` is updated
    # https://github.com/ngi-nix/ngipkgs/pull/1727#discussion_r2470180998
    ./pin-clojure.patch
  ];

  makeCacheWritable = true;

  npmDepsHash = "sha256-0dSFEZ02D83yplqT3GV9TyUwJ3lDjxM47pGYwUXzatw=";

  nativeBuildInputs = [
    finalAttrs.passthru.clojureWithHome
    makeWrapper
    copyDesktopItems
    pkg-config # sharp
  ];

  # For 'sharp' dependency, otherwise it will try to build it
  buildInputs = [ vips ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  postPatch = ''
    substituteInPlace shadow-cljs.edn \
      --replace-fail ":shadow-git-inject/version" '"v${finalAttrs.version}"'
  '';

  buildPhase = ''
    runHook preBuild

    electron_dist="$(mktemp -d)"
    cp -r ${electron.dist}/. "$electron_dist"
    chmod -R u+w "$electron_dist"

    npm run build
    npm exec electron-builder -- --dir \
      -c.electronDist="$electron_dist" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        # bash
        ''
          mkdir -p $out/Applications
          cp -r "dist/mac"*"/Repath Studio.app" "$out/Applications"
          makeWrapper "$out/Applications/Repath Studio.app/Contents/MacOS/Repath Studio" "$out/bin/repath-studio"
        ''
      else
        # bash
        ''
          mkdir -p $out/share/{repath-studio,icons/hicolor/scalable/apps}
          cp -r dist/*-unpacked/resources/app.asar $out/share/repath-studio
          cp resources/public/img/icon.svg $out/share/icons/hicolor/scalable/apps/repath-studio.svg

          makeWrapper '${lib.getExe electron}' "$out/bin/repath-studio" \
            --add-flags "$out/share/repath-studio/app.asar" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  # chromium package not available for darwin
  doCheck = stdenv.hostPlatform.isLinux;
  checkPhase = ''
    runHook preCheck
    export ELECTRON_OVERRIDE_DIST_PATH="$electron_dist"
    export PUPPETEER_EXECUTABLE_PATH=${chromium}/bin/chromium
    export CHROME_BIN=${chromium}/bin/chromium
    npm run test
    unset ELECTRON_OVERRIDE_DIST_PATH
    runHook postCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Repath Studio";
      desktopName = "Repath Studio";
      exec = "repath-studio %U";
      type = "Application";
      terminal = false;
      icon = "repath-studio";
      comment = "Vector graphics editor, that combines procedural tooling with traditional design workflows";
      categories = [ "Graphics" ];
    })
  ];

  passthru = {
    # this was taken and adapted from "logseq" package's nixpkgs derivation
    clojureHome = stdenv.mkDerivation {
      name = "repath-studio-${finalAttrs.version}-clojure-home";
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
        clojure -P -M:dev:cljs

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

      outputHash = "sha256-2ijBbKXKiXStWAyeLoRv8OSMoCfB2xA1TVw6xtlBPes=";
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
    };

    clojureWithHome = writeShellScriptBin "clojure" ''
      export HOME="${finalAttrs.passthru.clojureHome}"
      export JAVA_TOOL_OPTIONS="-Duser.home=${finalAttrs.passthru.clojureHome}"
      exec ${lib.getExe' clojure "clojure"} "$@"
    '';

    updateScript = ./update.sh;
    tests = { inherit (nixosTests) repath-studio; };
  };

  meta = {
    changelog = "https://github.com/repath-studio/repath-studio/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Cross-platform vector graphics editor, that combines procedural tooling with traditional design workflows";
    homepage = "https://repath.studio";
    downloadPage = "https://github.com/repath-studio/repath-studio";
    license = lib.licenses.agpl3Only;
    mainProgram = "repath-studio";
    maintainers = with lib.maintainers; [ phanirithvij ];
    teams = with lib.teams; [ ngi ];
    platforms = electron.meta.platforms;
  };
})
