{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  bun,
  writableTmpDirAsHomeHook,
  nodejs,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib-networking,
  librsvg,
  gdk-pixbuf,
  libayatana-appindicator,
  alsa-lib,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    # No first-class bun dependency fetcher exists in nixpkgs yet, so use the
    # established fixed-output derivation pattern: run `bun install` and pin the
    # resulting node_modules by outputHash. impureEnvVars lets proxy settings
    # through, like the standard fetchers do.
    bunDeps = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-bun-deps";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];
      dontConfigure = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$TMPDIR/bun-cache
        bun install --frozen-lockfile --no-progress --ignore-scripts --cpu="*" --os="*"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r node_modules $out/node_modules

        runHook postInstall
      '';

      dontFixup = true;
      outputHashMode = "recursive";
      outputHash = "sha256-whpXtZC2pIgJzly0txTjtg0QNabgRr+1qEzWZkKv3+U=";
    };
  in
  {
    pname = "mindwtr";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "dongdongbh";
      repo = "Mindwtr";
      tag = "v${finalAttrs.version}";
      hash = "sha256-nIMMzvjW0+jcw9/VtASxniAJPDF59Cl03XPUEEqWFf8=";
    };

    __structuredAttrs = true;

    cargoRoot = "apps/desktop/src-tauri";
    buildAndTestSubdir = "apps/desktop/src-tauri";
    cargoHash = "sha256-o1VqnlJcSRw8Zp+v45eEx/UlLtxt1treoqUVCwFqVe4=";

    # A transitive crate (tauri-plugin-http -> reqwest) pulls openssl-sys with the
    # vendored feature; link the store OpenSSL instead of building it from source.
    env.OPENSSL_NO_VENDOR = "1";

    # cmake is needed by whisper-rs-sys but there is no root CMakeLists.txt.
    dontUseCmakeConfigure = true;

    nativeBuildInputs = [
      cargo-tauri.hook
      bun # beforeBuildCommand runs `bun run build:vite`
      nodejs # provides `node` for patchShebangs
      rustPlatform.bindgenHook # libclang for bindgen (whisper-rs-sys)
      cmake
      pkg-config
      wrapGAppsHook3
    ];

    buildInputs = [
      webkitgtk_4_1
      gtk3
      libsoup_3
      glib-networking
      librsvg
      gdk-pixbuf
      libayatana-appindicator
      alsa-lib
      openssl
    ];

    preConfigure = ''
      cp -r ${bunDeps}/node_modules ./node_modules
      chmod -R u+w ./node_modules
      patchShebangs node_modules
    '';

    # libappindicator is dlopen'd at runtime; inject it into the wrapper's path.
    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
      )
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Local-first, privacy-first GTD task manager";
      homepage = "https://mindwtr.app";
      changelog = "https://github.com/dongdongbh/Mindwtr/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ pseb ];
      mainProgram = "mindwtr";
      platforms = lib.platforms.linux;
    };
  }
)
