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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadlock-mod-manager";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "deadlock-mod-manager";
    repo = "deadlock-mod-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4z9nwH4otPBZKHdl6Gc+F8UpIhLudWQS3SCcY0MTfQI=";
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-eIjFAXQCOUFI03vDIcLzbQXfNslTFUNut8m+coFJoTQ=";

  # Must match TAURI_CEF_TAG in apps/desktop/scripts/cef-patch.ts upstream
  tauriCefTag = "tauri-cef-v3.0.0-alpha.27";

  cargo-tauri-cef = cargo-tauri.overrideAttrs (
    tauriFinalAttrs: _: {
      version = "2.11.4-cef";
      src = fetchFromGitHub {
        owner = "tauri-apps";
        repo = "tauri";
        tag = finalAttrs.tauriCefTag;
        hash = "sha256-1YA+4dRH1wzj/U3trLZpEosm1SgK+boQXEKbvJw4mvY=";
      };
      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (tauriFinalAttrs) pname version src;
        hash = "sha256-FMC5A4ktEQN/2t8egdil/JuebdxJyDj2Sz5vxNGMngo=";
      };
      patches = [ ];
      doCheck = false;
    }
  );

  # ! cef-dll-sys / tauri-cli expect an *extracted, flattened* CEF distribution (libcef.so, *.pak, locales/, include/ side by side) plus an archive.json whose version is <= the `cef` crate's CEF version.
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

  # Swap in the CEF manifests + upstream's vendored Cargo.cef.lock.
  postUnpack = ''
    pushd "$sourceRoot/apps/desktop"

    upstreamTag=$(sed -n 's/.*TAURI_CEF_TAG ?? "\(.*\)";/\1/p' scripts/cef-patch.ts)
    if [ "$upstreamTag" != "${finalAttrs.tauriCefTag}" ]; then
      echo "upstream cef-patch.ts pins '$upstreamTag' but tauriCefTag is '${finalAttrs.tauriCefTag}'; bump it" >&2
      exit 1
    fi

    HOME="$TMPDIR" ${lib.getExe bun} scripts/cef-patch.ts prepare

    popd
  '';

  nativeBuildInputs = [
    finalAttrs.cargo-tauri-cef.hook
    nodejs
    pnpmConfigHook
    pnpm_11
    pkg-config
    protobuf
    wrapGAppsHook3
  ];

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
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-qgT14GNFoBCNMOIUWkmcuTYyMJ2nPtpuZ/+VNB2YwC8=";
  };

  patches = [
    ./no-updater-artifacts.patch
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "cef"
    "match-sync"
  ];
  tauriBuildFlags = [
    "--features"
    "cef"
    # The CEF branch trails crates.io, so Cargo.cef.lock is behind the @tauri-apps NPM packages.
    "--ignore-version-mismatches"
  ];

  env = {
    VITE_API_URL = "https://api.deadlockmods.app";
    CEF_PATH = "${finalAttrs.cefDist}";
  };

  # Shadow `strip` with a shim that makes its file arguments writable before calling the real one.
  preBuild = ''
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

  # The release profile rebuilds every test binary with fat LTO.
  checkType = "debug";

  preCheck = ''
    export LD_LIBRARY_PATH="${finalAttrs.cefDist}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';

  checkFlags = [
    # Requires network access
    "--skip=download_manager::downloader::tests::test_download_file"
    # Asserts that set_steam_dir rejects a non-Steam directory, but steamlocate
    # 2.1.0's SteamDir::from_dir only checks that the path is a directory
    # (further validation is an upstream TODO), so this fails in any environment.
    "--skip=mod_manager::steam_manager::tests::set_steam_dir_rejects_invalid_directory"
  ];

  postInstall = ''
    rm -f "$out/share/Deadlock Mod Manager/chrome-sandbox"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf"
      --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
      --add-flags "--disable-auto-update"
    )
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
    updateScript = lib.getExe (writeShellApplication {
      name = "update-deadlock-mod-manager";
      runtimeInputs = [
        nix-update
        gnused
      ];
      text = ''
        attr="''${UPDATE_NIX_ATTR_PATH:-deadlock-mod-manager}"

        # bump version + src hash only (cargoHash would fail before the tag is fixed)
        nix-update --src-only "$attr"

        # copy upstream's pinned CEF tag into the expression
        src=$(nix-build --no-out-link -A "$attr.src")
        tag=$(sed -n 's/.*TAURI_CEF_TAG ?? "\(.*\)";/\1/p' "$src/apps/desktop/scripts/cef-patch.ts")
        file=$(nix-instantiate --eval --raw -A "$attr.meta.position" | cut -d: -f1)
        sed -i "s|tauriCefTag = \".*\";|tauriCefTag = \"$tag\";|" "$file"

        # refresh every hash: the CLI, then cargoHash/pnpmDeps
        nix-update --version=skip \
          --subpackage cargo-tauri-cef \
          "$attr"
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
