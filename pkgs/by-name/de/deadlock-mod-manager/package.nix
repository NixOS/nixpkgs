{
  lib,
  fetchFromGitHub,
  rustPlatform,
  runCommand,
  bun,
  cargo-tauri,
  cef-binary,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  protobuf,
  wrapGAppsHook3,
  desktop-file-utils,
  cairo,
  gdk-pixbuf,
  glib,
  glib-networking,
  gtk3,
  pango,
  openssl,
  bzip2,
  makeDesktopItem,
  fontconfig,
  libayatana-appindicator,
  writeShellApplication,
  nix-update,
  gnused,
  aws-lc,
  sqlite,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  wayland,
  autoPatchelfHook,
  webkitgtk_4_1,
  libsoup_3,
  gst_all_1,
  # Use upstream's CEF runtime instead of WebKitGTK
  withCef ? false,
}:
let
  # Must match TAURI_CEF_TAG in upstream's apps/desktop/scripts/cef-patch.ts
  tauriCefTag = "tauri-cef-v3.0.0-alpha.27";

  cargo-tauri-cef = cargo-tauri.overrideAttrs (
    finalAttrs: _: {
      version = "2.11.4-cef";
      src = fetchFromGitHub {
        owner = "tauri-apps";
        repo = "tauri";
        tag = tauriCefTag;
        hash = "sha256-1YA+4dRH1wzj/U3trLZpEosm1SgK+boQXEKbvJw4mvY=";
      };
      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-FMC5A4ktEQN/2t8egdil/JuebdxJyDj2Sz5vxNGMngo=";
      };
      patches = [ ];
      doCheck = false;
    }
  );

  # cef-dll-sys and tauri-cli expect a flat CEF distribution with an archive.json
  cefDist = runCommand "cef-dist-${cef-binary.version}" { } ''
    mkdir -p $out/locales
    ln -s ${cef-binary}/${cef-binary.buildType}/* $out/
    for f in ${cef-binary}/Resources/*; do
      [ "$(basename "$f")" = locales ] || ln -s "$f" $out/
    done
    ln -s ${cef-binary}/Resources/locales/* $out/locales/
    ln -s ${cef-binary}/include $out/include
    cat > $out/archive.json <<EOF
    {"type": "minimal", "name": "cef_binary_${cef-binary.version}", "sha1": ""}
    EOF
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadlock-mod-manager";
  version = "2.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deadlock-mod-manager";
    repo = "deadlock-mod-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4z9nwH4otPBZKHdl6Gc+F8UpIhLudWQS3SCcY0MTfQI=";
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  # CEF builds use a different lockfile
  cargoHash =
    if withCef then
      "sha256-eIjFAXQCOUFI03vDIcLzbQXfNslTFUNut8m+coFJoTQ="
    else
      "sha256-7v8ItwFITLqUTY1pin5LQHKS8by9Hi3dxw2ZdF8tcMk=";

  # In postUnpack so fetchCargoVendor sees it too
  postUnpack = lib.optionalString withCef ''
    cp "$sourceRoot/apps/desktop/Cargo.cef.lock" "$sourceRoot/apps/desktop/Cargo.lock"
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    nodejs
    pnpmConfigHook
    pnpm_11
    pkg-config
    protobuf
    wrapGAppsHook3
  ]
  ++ (
    if withCef then
      [
        bun
        cargo-tauri-cef.hook
        autoPatchelfHook
      ]
    else
      [ cargo-tauri.hook ]
  );

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    glib-networking
    gtk3
    pango
    openssl
    bzip2
    libayatana-appindicator
    desktop-file-utils
    aws-lc
    sqlite
  ]
  ++ (
    if withCef then
      [
        libxkbcommon
        libGL
      ]
    else
      [
        webkitgtk_4_1
        libsoup_3
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
      ]
  );

  pnpmRoot = ".";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    sourceRoot = "source";
    hash = "sha256-qgT14GNFoBCNMOIUWkmcuTYyMJ2nPtpuZ/+VNB2YwC8=";
  };

  patches = [
    ./no-updater-artifacts.patch
  ];

  # Runs before cargoSetupPostPatchHook's lockfile check.
  postPatch =
    lib.optionalString withCef ''
      upstreamTag=$(sed -n 's/.*TAURI_CEF_TAG ?? "\(.*\)";/\1/p' apps/desktop/scripts/cef-patch.ts)
      if [ "$upstreamTag" != "${tauriCefTag}" ]; then
        echo "upstream cef-patch.ts pins '$upstreamTag' but tauriCefTag is '${tauriCefTag}'; bump it" >&2
        exit 1
      fi

      # Upstream's CEF Cargo.toml patching
      (cd apps/desktop && bun scripts/cef-patch.ts prepare)
    ''
    + ''
      substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

  buildNoDefaultFeatures = withCef;
  # Same features as upstream's CEF build
  buildFeatures = lib.optionals withCef [
    "cef"
    "match-sync"
  ];
  tauriBuildFlags = lib.optionals withCef [
    "--features"
    "cef"
    "--config"
    "src-tauri/tauri.cef.conf.json"
  ];

  env = {
    VITE_API_URL = "https://api.deadlockmods.app";
  }
  // lib.optionalAttrs withCef {
    # Makes tauri-cli skip its npm/Rust version check, as when run via pnpm upstream
    npm_config_user_agent = "pnpm/${pnpm_11.version} npm/? node/v${nodejs.version} linux x64";
    CEF_PATH = "${cefDist}";
  };

  # tauri-cli strips the read-only CEF files it copies from the store
  preBuild = lib.optionalString withCef ''
    realStrip=$(command -v strip)
    mkdir -p "$TMPDIR/strip-shim"
    cat > "$TMPDIR/strip-shim/strip" <<EOF
    #!$SHELL
    for arg in "\$@"; do
      if [ -f "\$arg" ]; then chmod u+w -- "\$arg"; fi
    done
    exec "$realStrip" "\$@"
    EOF
    chmod +x "$TMPDIR/strip-shim/strip"
    export PATH="$TMPDIR/strip-shim:$PATH"
  '';

  preCheck = lib.optionalString withCef ''
    export LD_LIBRARY_PATH="${cefDist}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';

  checkFlags = [
    # Requires network access
    "--skip=download_manager::downloader::tests::test_download_file"
    # steamlocate doesn't validate Steam directories yet
    "--skip=mod_manager::steam_manager::tests::set_steam_dir_rejects_invalid_directory"
  ];

  postInstall = lib.optionalString withCef ''
    rm -f "$out/share/Deadlock Mod Manager/chrome-sandbox"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf"
      --set TAURI_DIST_DIR "$out/share/deadlock-modmanager/dist"
      --set DISABLE_UPDATE_DESKTOP_DATABASE 1
      --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
      --add-flags "--disable-auto-update"
    )
  '';

  # dlopen'd by winit
  runtimeDependencies = lib.optionals withCef [
    libGL
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    wayland
  ];

  # The bundled CEF libraries are already patched by cef-binary
  dontAutoPatchelf = withCef;
  # CEF's libGLESv2.so needs libGL.so.1 but has no RPATH to it
  postFixup = lib.optionalString withCef ''
    patchelf --add-needed libGL.so.1 "$out/share/Deadlock Mod Manager/deadlock-mod-manager"
    addAutoPatchelfSearchPath "$out/share/Deadlock Mod Manager"
    autoPatchelf "$out/share/Deadlock Mod Manager/deadlock-mod-manager"
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "deadlock-mod-manager";
      name = "Deadlock Mod Manager";
      exec = "deadlock-mod-manager %u";
      terminal = false;
      type = "Application";
      icon = "deadlock-mod-manager";
      mimeTypes = [ "x-scheme-handler/deadlock-mod-manager" ];
      categories = [
        "Utility"
        "Game"
      ];
    })
  ];

  passthru = {
    inherit cefDist cargo-tauri-cef;

    updateScript = lib.getExe (writeShellApplication {
      name = "update-deadlock-mod-manager";
      runtimeInputs = [
        nix-update
        gnused
      ];
      text = ''
        # also run for deadlock-mod-manager-cef
        attr="''${UPDATE_NIX_ATTR_PATH:-deadlock-mod-manager}"
        attr="''${attr%-cef}"

        # src only: cargoHash needs the new CEF tag first
        nix-update --src-only "$attr"

        src=$(nix-build --no-out-link -A "$attr.src")
        tag=$(sed -n 's/.*TAURI_CEF_TAG ?? "\(.*\)";/\1/p' "$src/apps/desktop/scripts/cef-patch.ts")
        file=$(nix-instantiate --eval --raw -A "$attr.meta.position" | cut -d: -f1)
        sed -i "s|tauriCefTag = \".*\";|tauriCefTag = \"$tag\";|" "$file"

        nix-update --version=skip \
          --subpackage cargo-tauri-cef \
          "$attr"

        nix-update --version=skip "$attr-cef"
      '';
    });
  };

  meta = {
    description = "Mod manager for the Valve game Deadlock";
    homepage = "https://github.com/deadlock-mod-manager/deadlock-mod-manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mistyttm
      schromp
    ];
    teams = [ lib.teams.gaming ];
    platforms = lib.platforms.linux;
    mainProgram = "deadlock-mod-manager";
  };
})
