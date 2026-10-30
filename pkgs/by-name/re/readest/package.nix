{
  lib,
  addDriverRunpath,
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
  # speechd-minimal,
  wrapGAppsHook3,
  xdg-utils,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "readest";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "readest";
    repo = "readest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XNN66MB13yqHCvnBUgPmdghRnXA7Kz13E0j82EqxocU=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/apps/readest-app";

  patches = [
    # Use the installed desktop entry so URI launches go through the Nix wrapper.
    ./use-installed-uri-handlers.patch
  ];

  pnpmRoot = "../..";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-LPm50VC7KU1wysxSUxwFZ7pNZutULct05NB5WgjmTws=";
    pnpmInstallFlags = [
      # Retry transient fetch timeouts on slow networks.
      "--fetch-retries=5"
    ];
  };

  cargoRoot = "../..";
  cargoHash = "sha256-tPd67GAyyVxwMtVRdjEy/GL9e9p6twTVqD3Xd6OlvO0=";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm_11
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
    autoAddDriverRunpath
  ];

  buildInputs = [
    cef-binary
    gtk3
    librsvg
    openssl
  ];

  # Winit's X11 backend loads these dynamically; autoPatchelf cannot discover them.
  runtimeDependencies = [
    libx11
    libxcursor
    libxi
    libxrandr
    libxkbcommon
  ];

  buildAndTestSubdir = "src-tauri";

  buildFeatures = [ "cef" ];
  buildNoDefaultFeatures = true;

  # Skip WebKit/GStreamer setup; preserve the NVIDIA workaround in preFixup.
  # https://github.com/NixOS/nixpkgs/blob/964f593dcb68c9be87ea8b1b2fd5c093c81a3e1c/pkgs/by-name/ca/cargo-tauri/hook.nix#L39-L48
  dontTauriFixup = true;

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

  preBuild = ''
    # Read the required CEF major from the lockfile validated by cargoSetupHook.
    cefVersion=$(awk '
      $1 == "name" { isCef = ($3 == "\"cef-dll-sys\"") }
      isCef && $1 == "version" { gsub(/"/, "", $3); print $3; exit }
    ' "$cargoDepsLockfile")
    if [ -z "$cefVersion" ]; then
      echo "readest: cef-dll-sys is missing from Cargo.lock" >&2
      exit 1
    fi
    cefMajor="''${cefVersion%%.*}"
    if [ "$cefMajor" != "${lib.versions.major cef-binary.version}" ]; then
      echo "readest: cef-dll-sys $cefVersion requires CEF $cefMajor, but cef-binary is ${cef-binary.version}" >&2
      exit 1
    fi

    export CEF_PATH="$NIX_BUILD_TOP/cef"
    mkdir -p "$CEF_PATH"

    # The Rust bindings expect the runtime libraries and resources in one directory.
    # https://github.com/chromiumembedded/cef/blob/be1e15d/tools/distrib/linux/README.minimal.txt
    ln -s ${cef-binary}/Release/* ${cef-binary}/Resources/* "$CEF_PATH/"
    ln -s ${cef-binary}/include "$CEF_PATH/include"

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

    mkdir -p $out/lib/readest
    mv $out/bin/readest $out/lib/readest/readest

    ln -s ../lib/readest/readest $out/bin/readest

    # CEF's runtime libraries and resources belong next to the executable.
    # https://github.com/chromiumembedded/cef/blob/be1e15d/tools/distrib/linux/README.minimal.txt
    ln -s ${cef-binary}/Release/* ${cef-binary}/Resources/* "$out/lib/readest/"
  '';

  preFixup = ''
    # CEF dlopens PulseAudio; ANGLE needs libGL and GPU drivers.
    # The shared CEF libraries are symlinks, so our fixup hooks skip them.
    # Use the wrapper's search path for loads originating in those libraries.
    gappsWrapperArgs+=(
      # Preserve cargo-tauri.hook's NVIDIA explicit-sync workaround because
      # dontTauriFixup = true disables the hook's entire fixup script.
      --set-default __NV_DISABLE_EXPLICIT_SYNC 1
      # The opener plugin uses xdg-open to launch the browser for OAuth.
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          addDriverRunpath.driverLink
          libGL
          libpulseaudio
          # Uncomment when CEF enables its Speech Dispatcher backend for local
          # Web Speech voices; a configured Speech Dispatcher service is also required.
          # speechd-minimal
        ]
      }"
    )

    # CEF locates ICU data relative to the loaded libcef.so. Load it through
    # our symlink next to the resources, after autoPatchelf has set its RUNPATH.
    fixCefRunpath() {
      patchelf --set-rpath \
        '$ORIGIN:'"$(patchelf --print-rpath "$out/lib/readest/readest")" \
        "$out/lib/readest/readest"
    }
    postFixupHooks+=(fixCefRunpath)
  '';

  passthru.updateScript = nix-update-script { };

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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
