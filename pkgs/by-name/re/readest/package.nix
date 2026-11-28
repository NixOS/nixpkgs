{
  lib,
  addDriverRunpath,
  alsa-lib,
  autoAddDriverRunpath,
  autoPatchelfHook,
  cargo-tauri,
  cef-binary,
  fetchFromGitHub,
  fetchPnpmDeps,
  gtk3,
  libGL,
  libpulseaudio,
  librsvg,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpmConfigHook,
  pnpm_11,
  rustPlatform,
  wrapGAppsHook3,
  xdg-utils,
  xz,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "readest";
  version = "0.12.20";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7rAQwden1p9zL7gCn54H0mT/XtjmWlwZ2GA9hr4FyRU=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/apps/readest-app";

  patches = [
    # Use the installed desktop entry so URI launches go through the Nix wrapper.
    ./use-installed-uri-handlers.patch
  ];

  postUnpack = ''
    # pnpmConfigHook has to write to ../.., as our sourceRoot is set to
    # apps/readest-app
    chmod -R +w .

    # Select upstream's CEF lockfile and matching Tauri/Cargo overrides.
    cp "$sourceRoot/../../Cargo.cef.lock" \
       "$sourceRoot/../../Cargo.lock"

    cp "$sourceRoot/src-tauri/.cargo/cef.toml" \
       "$sourceRoot/src-tauri/.cargo/config.toml"
  '';

  pnpmRoot = "../..";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 5;
    hash = "sha256-sFWLTnf5WHNv2qVNkJbZD2iXSXBH3jvTOEdKLjwK7V4=";
  };

  cargoRoot = "../..";
  cargoHash = "sha256-gG1u9jMtYMEOnmzzWsWdG8otjCdxmX+dthalUYFaNGU=";

  buildAndTestSubdir = "src-tauri";

  buildFeatures = [ "cef" ];
  buildNoDefaultFeatures = true;

  # Skip WebKit/GStreamer setup; preserve the NVIDIA workaround in preFixup.
  # https://github.com/NixOS/nixpkgs/blob/964f593dcb68c9be87ea8b1b2fd5c093c81a3e1c/pkgs/by-name/ca/cargo-tauri/hook.nix#L39-L48
  dontTauriFixup = true;

  postPatch = ''
    # Use nixpkgs' CEF distribution instead of the crate's download cache.
    # The archive metadata check otherwise triggers a separate download.
    substituteInPlace $cargoDepsCopy/source-registry-*/cef-dll-sys-*/build.rs \
      --replace-fail \
        'download_cef::check_archive_json(&package_version, &path.to_string_lossy())?;' \
        ""

    # The frontend is built explicitly in preBuild.
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail \
        '"beforeBuildCommand": "pnpm build && pnpm upload-sourcemaps"' \
        '"beforeBuildCommand": ""' \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"productName": "Readest"' '"productName": "readest"'

    # Do not generate browser source maps; the upstream cleanup step is skipped.
    substituteInPlace next.config.mjs \
      --replace-fail \
        'productionBrowserSourceMaps: exportOutput' \
        'productionBrowserSourceMaps: false'

    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false" \
      --replace-fail "telemetryEnabled: true" "telemetryEnabled: false"
  '';

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
    cargo-tauri.hook
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm_11
    rustPlatform.bindgenHook
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    gtk3
    librsvg
    openssl
  ];

  runtimeDependencies = [
    # Loaded by Winit's X11 backend
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
  ];

  env.CEF_PATH = finalAttrs.passthru.cefPath;

  preBuild = ''
    # Assert that `cef-dll-sys` and `cef-binary`'s major versions are the same
    cefMajor=$(
      grep -A1 '^name = "cef-dll-sys"$' "$cargoDepsLockfile" |
        sed -nE 's/^version = "([0-9]+)\..*/\1/p'
    )

    if [ "$cefMajor" != "${lib.versions.major cef-binary.version}" ]; then
      echo "readest: Cargo.lock wants CEF major '$cefMajor', but cef-binary is ${cef-binary.version}" >&2
      exit 1
    fi

    # Set up pdf.js assets.
    pnpm setup-vendors

    # Tauri embeds frontendDist during the Rust build.
    pnpm --filter @readest/readest-app build
  '';

  postInstall = ''
    # Pass OAuth callback URLs and opened files to the application.
    # Remove once cargo-tauri includes https://github.com/tauri-apps/tauri/pull/15929.
    substituteInPlace "$out/share/applications/readest.desktop" \
      --replace-fail $'Exec=readest\n' $'Exec=readest %U\n'
  '';

  preFixup = ''
    addAutoPatchelfSearchPath --no-recurse ${finalAttrs.passthru.cefPath}

    gappsWrapperArgs+=(
      # Preserve cargo-tauri.hook's NVIDIA explicit-sync workaround because
      # dontTauriFixup = true disables the hook's entire fixup script.
      --set-default __NV_DISABLE_EXPLICIT_SYNC 1

      # The opener plugin uses xdg-open to launch the browser for OAuth.
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"

      # CEF dlopens PulseAudio; ANGLE needs libGL and GPU drivers.
      # Provide search paths for loads originating in the separate CEF libraries.
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          addDriverRunpath.driverLink
          libGL
          libpulseaudio
        ]
      }"
    )
  '';

  passthru = {
    cefPath = cef-binary.overrideAttrs {
      pname = "cef-path";

      postInstall = ''
        find $out -mindepth 1 -delete
        strip ./Release/*.so*
        mv ./Release/* $out/
        mv ./Resources/* $out/
        mv ./include $out/

        ${xz}/bin/xz -9 -e -c ./CREDITS.html > "$out/CREDITS.html.xz"
      '';
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern, feature-rich ebook reader";
    homepage = "https://github.com/readest/readest";
    changelog = "https://github.com/readest/readest/releases/tag/v${finalAttrs.version}";
    mainProgram = "readest";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      eljamm
      kasifrasi
    ];
    platforms = cef-binary.meta.platforms;
  };
})
