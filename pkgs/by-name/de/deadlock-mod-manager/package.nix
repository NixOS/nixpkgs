{
  lib,
  fetchFromGitHub,
  rustPlatform,
  runCommand,
  stdenvNoCC,
  bun,
  cargo,
  cacert,
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
let
  # Must match TAURI_CEF_TAG in apps/desktop/scripts/cef-patch.ts upstream
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadlock-mod-manager";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "deadlock-mod-manager";
    repo = "deadlock-mod-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5cEM/ysJ62LWcjQ9ww1PnsDn1g0jktxTEiGhRKFE8xw=";
  };

  cargoRoot = "apps/desktop";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-qEDzikmCDV7/QAdwpTqLAionz//BYMap+SqCI2/3u/Y=";

  # Swap in the CEF manifests + lockfile.
  postUnpack = ''
    for f in Cargo.toml Cargo.lock src-tauri/Cargo.toml; do
      install -m644 ${finalAttrs.passthru.cefManifests}/$f "$sourceRoot/apps/desktop/$f"
    done
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo-tauri-cef.hook
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
    hash = "sha256-K5s7MzPiQdsnQOwWueDn4rZUsfZeH9b6PNDFRaivisQ=";
  };

  patches = [
    ./no-updater-artifacts.patch
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [ "cef" ];
  tauriBuildFlags = [
    "--features"
    "cef"
  ];

  env = {
    VITE_API_URL = "https://api.deadlockmods.app";
    CEF_PATH = "${cefDist}";
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

  preCheck = ''
    export LD_LIBRARY_PATH="${cefDist}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
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
      --set TAURI_DIST_DIR "$out/share/deadlock-modmanager/dist"
      --set DISABLE_UPDATE_DESKTOP_DATABASE 1
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
    inherit cefDist cargo-tauri-cef;

    # Runs upstream's own scripts/cef-patch.ts against the source
    cefManifests = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-cef-manifests";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        bun
        cargo
        cacert
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        cd apps/desktop

        upstreamTag=$(sed -n 's/.*TAURI_CEF_TAG ?? "\(.*\)";/\1/p' scripts/cef-patch.ts)
        if [ "$upstreamTag" != "${tauriCefTag}" ]; then
          echo "upstream cef-patch.ts pins '$upstreamTag' but tauriCefTag is '${tauriCefTag}'; bump it" >&2
          exit 1
        fi

        export HOME="$TMPDIR" CARGO_HOME="$TMPDIR/cargo"
        # `true` is the command the script wraps; we only want its injection step.
        bun scripts/cef-patch.ts true

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm644 Cargo.toml $out/Cargo.toml
        install -Dm644 Cargo.lock $out/Cargo.lock
        install -Dm644 src-tauri/Cargo.toml $out/src-tauri/Cargo.toml
        runHook postInstall
      '';

      dontFixup = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-ciP1nPgUMUrOXFqt8E5iFwRaNbm+TZO8XllxFjKoMvg=";
    };

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

        # refresh every hash: manifests, then the CLI, then cargoHash/pnpmDeps
        nix-update --version=skip \
          --subpackage cefManifests \
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
