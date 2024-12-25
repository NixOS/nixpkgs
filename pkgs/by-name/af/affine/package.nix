{
  cacert,
  cargo,
  copyDesktopItems,
  electron_33,
  fetchFromGitHub,
  fetchurl,
  findutils,
  jq,
  lib,
  makeDesktopItem,
  makeWrapper,
  nodejs_20,
  rsync,
  rustPlatform,
  rustc,
  stdenv,
  stdenvNoCC,
  yarn,
  zip,
  buildType ? "stable",
  commandLineArgs ? "",
}:
let
  hostPlatform = stdenvNoCC.hostPlatform;
  nodePlatform = hostPlatform.parsed.kernel.name; # nodejs's `process.platform`
  nodeArch = # nodejs's `process.arch`
    {
      "x86_64" = "x64";
      "aarch64" = "arm64";
    }
    .${hostPlatform.parsed.cpu.name}
      or (throw "affine(${buildType}): unsupported CPU family ${hostPlatform.parsed.cpu.name}");
  electron = electron_33;
in
stdenv.mkDerivation (
  finalAttrs:
  (
    {
      productName = if buildType == "stable" then "AFFiNE" else "AFFiNE-" + buildType;
      binName = lib.toLower finalAttrs.productName;
      pname = finalAttrs.binName;

      # https://github.com/toeverything/AFFiNE/releases/tag/v0.18.1
      version = "0.18.1";
      GITHUB_SHA = "8b066a4b398aace25a20508a8e3c1a381721971f";
      src = fetchFromGitHub {
        owner = "toeverything";
        repo = "AFFiNE";
        rev = finalAttrs.GITHUB_SHA;
        hash = "sha256-TWwojG3lqQlQFX3BKoFjJ27a3T/SawXgNDO6fP6gW4k=";
      };

      meta =
        {
          description = "Workspace with fully merged docs, whiteboards and databases";
          longDescription = ''
            AFFiNE is an open-source, all-in-one workspace and an operating
            system for all the building blocks that assemble your knowledge
            base and much more -- wiki, knowledge management, presentation
            and digital assets
          '';
          homepage = "https://affine.pro/";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ xiaoxiangmoe ];
          platforms = [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
          ];
          sourceProvenance = [ lib.sourceTypes.fromSource ];
        }
        // lib.optionalAttrs hostPlatform.isLinux {
          mainProgram = finalAttrs.binName;
        };

      env = {
        BUILD_TYPE = buildType;
      };
      cargoDeps = rustPlatform.fetchCargoVendor {
        src = finalAttrs.src;
        hash = "sha256-5s/X9CD/H9rSn7SqMHioLg1KRP7y9fsozdFRY3hNiP8=";
      };
      yarnOfflineCache = stdenvNoCC.mkDerivation {
        name = "yarn-offline-cache";
        src = finalAttrs.src;
        nativeBuildInputs = [
          yarn
          cacert
        ];
        supportedArchitectures = builtins.toJSON {
          os = [
            "darwin"
            "linux"
          ];
          cpu = [
            "arm64"
            "x64"
          ];
          libc = [
            "glibc"
            "musl"
          ];
        };
        buildPhase = ''
          export HOME="$NIX_BUILD_TOP"
          export CI=1

          mkdir -p $out
          yarn config set enableTelemetry false
          yarn config set cacheFolder $out
          yarn config set enableGlobalCache false
          yarn config set supportedArchitectures --json "$supportedArchitectures"

          yarn install --immutable --mode=skip-build
        '';
        dontInstall = true;
        outputHashMode = "recursive";
        outputHash = "sha256-HueTia+1ApfvbBK/b+iE84TB1DCWIDLoQ9XhjYlGCUs=";
      };
      nativeBuildInputs =
        [
          nodejs_20
          yarn
          cargo
          rustc
          findutils
          zip
          jq
          rsync
        ]
        ++ lib.optionals hostPlatform.isLinux [
          copyDesktopItems
          makeWrapper
        ];

      patchPhase = ''
        runHook prePatchPhase

        sed -i '/packagerConfig/a \    electronZipDir: process.env.ELECTRON_FORGE_ELECTRON_ZIP_DIR,' packages/frontend/apps/electron/forge.config.mjs

        runHook postPatchPhase
      '';

      configurePhase =
        let
          electronContentPath =
            electron + (if hostPlatform.isLinux then "/libexec/electron/" else "/Applications/");
        in
        ''
          runHook preConfigurePhase

          export HOME="$NIX_BUILD_TOP"
          export CI=1

          # cargo config
          mkdir -p .cargo
          cat $cargoDeps/.cargo/config.toml >> .cargo/config.toml
          ln -s $cargoDeps @vendor@

          # yarn config
          yarn config set enableTelemetry false
          yarn config set enableGlobalCache false
          yarn config set cacheFolder $yarnOfflineCache

          # electron config
          ELECTRON_VERSION_IN_LOCKFILE=$(yarn why electron --json | tail --lines 1 | jq --raw-output '.children | to_entries | first | .key ' | cut -d : -f 2)
          rsync --archive --chmod=u+w ${electronContentPath} $HOME/.electron-prebuilt-zip-tmp
          export ELECTRON_FORGE_ELECTRON_ZIP_DIR=$PWD/.electron_zip_dir
          mkdir -p $ELECTRON_FORGE_ELECTRON_ZIP_DIR
          (cd $HOME/.electron-prebuilt-zip-tmp && zip --recurse-paths - .) > $ELECTRON_FORGE_ELECTRON_ZIP_DIR/electron-v$ELECTRON_VERSION_IN_LOCKFILE-${nodePlatform}-${nodeArch}.zip
          export ELECTRON_SKIP_BINARY_DOWNLOAD=1

          runHook postConfigurePhase
        '';
      buildPhase = ''
        runHook preBuild

        # first build
        yarn workspaces focus @affine/electron @affine/monorepo
        CARGO_NET_OFFLINE=true yarn workspace @affine/native build
        BUILD_TYPE=${buildType} SKIP_NX_CACHE=1 yarn workspace @affine/electron generate-assets

        # second build
        yarn config set nmMode classic
        yarn config set nmHoistingLimits workspaces
        find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
        yarn workspaces focus @affine/electron @affine/monorepo
        BUILD_TYPE=${buildType} SKIP_WEB_BUILD=1 SKIP_BUNDLE=1 HOIST_NODE_MODULES=1 yarn workspace @affine/electron make

        runHook postBuild
      '';
      installPhase =
        let
          inherit (finalAttrs) binName productName;
        in
        if hostPlatform.isDarwin then
          ''
            runHook preInstall

            mkdir -p $out/Applications
            mv packages/frontend/apps/electron/out/${buildType}/${productName}-darwin-${nodeArch}/${productName}.app $out/Applications

            runHook postInstall
          ''
        else
          ''
            runHook preInstall

            mkdir --parents $out/lib/${binName}/
            mv packages/frontend/apps/electron/out/${buildType}/${productName}-linux-${nodeArch}/{resources,LICENSE*} $out/lib/${binName}/
            install -Dm644 packages/frontend/apps/electron/resources/icons/icon_${buildType}_64x64.png $out/share/icons/hicolor/64x64/apps/${binName}.png

            makeWrapper "${electron}/bin/electron" $out/bin/${binName} \
              --inherit-argv0 \
              --add-flags $out/lib/${binName}/resources/app.asar \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
              --add-flags ${lib.escapeShellArg commandLineArgs}

            runHook postInstall
          '';
    }
    // (lib.optionalAttrs hostPlatform.isLinux {
      desktopItems =
        let
          inherit (finalAttrs) binName productName;
        in
        [
          (makeDesktopItem {
            name = binName;
            desktopName = productName;
            comment = "AFFiNE Desktop App";
            exec = "${binName} %U";
            terminal = false;
            icon = binName;
            startupWMClass = binName;
            categories = [ "Utility" ];
            mimeTypes = [ "x-scheme-handler/${binName}" ];
          })
        ];
    })
  )
)
