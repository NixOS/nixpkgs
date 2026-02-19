{
  lib,
  stdenv,

  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  electron,
  chromium,
  clojure,
  vips,

  writeShellScriptBin,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  replaceVars,

  vulkan-loader,
}:
buildNpmPackage (finalAttrs: {
  pname = "repath-studio";
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "repath-studio";
    repo = "repath-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sdM3owUYI0P12+R4YyYtF/20Zl0EpJY6t4Z1q/K5EqM=";
  };

  patches = [
    (replaceVars ./hardcode-git-paths.patch {
      clj-kdtree_src = fetchFromGitHub {
        owner = "abscondment";
        repo = "clj-kdtree";
        rev = "5ec321c5e8006db00fa8b45a8ed9eb0b8f3dd56d";
        hash = "sha256-ZOv+9TxBsOnSSbfM7kJLP3cQH9FpgA15aETszg7YSes=";
      };
    })
    # outputHash of manvenDeps changes each time `clojure` is updated
    # https://github.com/ngi-nix/ngipkgs/pull/1727#discussion_r2470180998
    ./pin-clojure.patch
  ];

  makeCacheWritable = true;

  npmDepsHash = "sha256-Zihy5VYlkeQtmZUS25kgu3aYGPfQdUxjNSK33WHOEeQ=";

  nativeBuildInputs = [
    finalAttrs.passthru.clojureWithCache
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

  passthru = {
    # this was taken and adapted from "logseq" package's nixpkgs derivation
    mavenRepo = stdenv.mkDerivation {
      name = "repath-studio-${finalAttrs.version}-maven-deps";
      inherit (finalAttrs) src patches;

      nativeBuildInputs = [ clojure ];

      buildPhase = ''
        runHook preBuild

        export HOME="$(mktemp -d)"
        mkdir -p "$out"

        # -P       -> resolve all normal deps
        # -M:alias -> resolve extra-deps of the listed aliases
        clj -Sdeps "{:mvn/local-repo \"$out\"}" -P -M:dev:cljs

        runHook postBuild
      '';

      # copied from buildMavenPackage
      # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
      installPhase = ''
        runHook preInstall

        find $out -type f \( \
          -name \*.lastUpdated \
          -o -name resolver-status.properties \
          -o -name _remote.repositories \) \
          -delete

        runHook postInstall
      '';

      dontFixup = true;

      outputHash = "sha256-ytS7JiQUC7U0vxuQddxQfDnm0Pt4stkRBfiIlbOpeTk=";
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
    };

    clojureWithCache = writeShellScriptBin "clojure" ''
      exec ${lib.getExe' clojure "clojure"} -Sdeps '{:mvn/local-repo "${finalAttrs.passthru.mavenRepo}"}' "$@"
    '';
  };

  buildPhase = ''
    runHook preBuild

    # electronDist needs to be modifiable
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  ''
  # Electron builder complains about symlink in electron-dist
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    rm electron-dist/libvulkan.so.1
    cp ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 electron-dist
  ''
  + ''
    npm run build
    npm exec electron-builder -- --dir \
      -c.electronDist=electron-dist \
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
    export ELECTRON_OVERRIDE_DIST_PATH=electron-dist/
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

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/repath-studio/repath-studio/blob/v${finalAttrs.src.rev}/CHANGELOG.md";
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
