{
  stdenv,
  rustPlatform,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  cargo-tauri,
  nodejs,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook3,
  fetchFromGitHub,
  gtk3,
  librsvg,
  openssl,
  autoPatchelfHook,
  lib,
  nix-update-script,
  moreutils,
  jq,
  xdg-utils,

  cef-binary,
  autoAddDriverRunpath,
  addDriverRunpath,
  libGL,
  libpulseaudio,
  speechd-minimal,
  libx11,
  libxrandr,
  libxkbcommon,
  libxcursor,
  libxi,
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

  patches = [
    # Nix-specific: keep URI handlers pointing at the installed application wrapper.
    ./use-installed-uri-handlers.patch
  ];
  postUnpack = ''
    # pnpm.configHook has to write to ../.., as our sourceRoot is set to
    # apps/readest-app
    chmod -R +w .

    cp "$sourceRoot/../../Cargo.cef.lock" \
         "$sourceRoot/../../Cargo.lock"

    cp "$sourceRoot/src-tauri/.cargo/cef.toml" \
      "$sourceRoot/src-tauri/.cargo/config.toml"
  '';

  sourceRoot = "${finalAttrs.src.name}/apps/readest-app";

  pnpmRoot = "../..";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-LPm50VC7KU1wysxSUxwFZ7pNZutULct05NB5WgjmTws=";
    pnpmInstallFlags = [
      # Increase number of fetch attempts to work around timeout issues on slow
      # networks: "TimeoutError: The operation was aborted due to timeout".
      #
      # If this still happens on your network, consider changing some of the
      # fetch setting and opening a pull request:
      # https://pnpm.io/settings#request-settings
      "--fetch-retries=5"
    ];
  };

  cargoRoot = "../..";
  cargoHash = "sha256-tPd67GAyyVxwMtVRdjEy/GL9e9p6twTVqD3Xd6OlvO0=";

  buildAndTestSubdir = "src-tauri";

  buildFeatures = [ "cef" ];
  buildNoDefaultFeatures = true;
  doCheck = false;

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
    # Keep desktop URI schemes for OAuth callbacks; omit mobile-only entries.
    jq 'del(.plugins."deep-link".mobile)' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    substituteInPlace src/services/constants.ts \
      --replace-fail "autoCheckUpdates: true" "autoCheckUpdates: false" \
      --replace-fail "telemetryEnabled: true" "telemetryEnabled: false"

    jq '.version = "${finalAttrs.version}"' package.json | sponge package.json

    mkdir -p src-tauri/plugins/tauri-plugin-turso/dist-js
    cp -r ${finalAttrs.passthru.tursoPlugin}/. src-tauri/plugins/tauri-plugin-turso/dist-js/
    jq '.scripts.build = "true"' \
      src-tauri/plugins/tauri-plugin-turso/package.json | \
      sponge src-tauri/plugins/tauri-plugin-turso/package.json
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm_11
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
    moreutils
    jq
    autoAddDriverRunpath
  ];

  buildInputs = [
    cef-binary
    # Some plugins still compile the unused Wry backend.
    webkitgtk_4_1
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

  preBuild = ''
    # The Rust CEF bindings in Cargo.cef.lock target CEF 151.
    # Fail during the build so nixpkgs-review reports incompatible CEF updates.
    if [ "${lib.versions.major cef-binary.version}" != "151" ]; then
      echo "readest: check the Rust CEF bindings before using cef-binary ${cef-binary.version} (expected CEF 151)" >&2
      exit 1
    fi

    export CEF_PATH="$NIX_BUILD_TOP/cef"
    mkdir -p "$CEF_PATH"

    # The Rust bindings expect the runtime libraries and resources in one directory.
    ln -s ${cef-binary}/Release/* ${cef-binary}/Resources/* "$CEF_PATH/"
    ln -s ${cef-binary}/include "$CEF_PATH/include"

    # set up pdfjs and simplecc
    pnpm setup-vendors

    # tauri-plugin-turso requires frontendDist to exist during the Rust build.
    pnpm --filter @readest/readest-app build
  '';

  postInstall = ''
    # Pass OAuth callback URLs and opened files to the application.
    substituteInPlace "$out/share/applications/readest.desktop" \
      --replace-fail $'Exec=readest\n' $'Exec=readest %U\n'

    # Follow upstream's CEF packaging by removing unused WebKit dependencies.
    # Check for references before removing their DT_NEEDED entries.
    $NM -D --undefined-only "$out/bin/readest" > readest-undefined-symbols.txt

    if grep -Eq ' (webkit_|jsc_|JS[A-Z]|soup_)' readest-undefined-symbols.txt; then
      echo "readest references WebKitGTK/libsoup symbols; cannot drop the libraries" >&2
      exit 1
    fi
    patchelf --remove-needed libwebkit2gtk-4.1.so.0 --remove-needed libjavascriptcoregtk-4.1.so.0 \
      --remove-needed libsoup-3.0.so.0 $out/bin/readest
    mkdir -p $out/lib/readest
    mv $out/bin/readest $out/lib/readest/readest

    ln -s ../lib/readest/readest $out/bin/readest

    for file in \
      libcef.so \
      libEGL.so \
      libGLESv2.so \
      libvk_swiftshader.so \
      libvulkan.so.1 \
      vk_swiftshader_icd.json \
      chrome_100_percent.pak \
      chrome_200_percent.pak \
      resources.pak \
      icudtl.dat \
      v8_context_snapshot.bin
    do
      ln -s "$(readlink -f "$CEF_PATH/$file")" $out/lib/readest/
    done

    ln -s "$(readlink -f "$CEF_PATH/locales")" $out/lib/readest/
  '';

  preFixup = ''
    # CEF dlopens PulseAudio; ANGLE needs libGL and GPU drivers.
    # The shared CEF libraries are symlinks, so our fixup hooks skip them.
    # Use the wrapper's search path for loads originating in those libraries.
    gappsWrapperArgs+=(
      # The opener plugin uses xdg-open to launch the browser for OAuth.
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          addDriverRunpath.driverLink
          libGL
          libpulseaudio
          # Provide libspeechd for a future upstream activation of CEF's
          # Speech Dispatcher backend for local Web Speech voices.
          # The library alone does not enable it; a configured service is also needed.
          speechd-minimal
        ]
      }"
    )

    addAutoPatchelfSearchPath ${cef-binary}/Release

    # CEF locates ICU data relative to the loaded libcef.so. Load it through
    # our symlink next to the resources, after autoPatchelf has set its RUNPATH.
    fixCefRunpath() {
      patchelf --set-rpath \
        '$ORIGIN:'"$(patchelf --print-rpath "$out/lib/readest/readest")" \
        "$out/lib/readest/readest"
    }
    postFixupHooks+=(fixCefRunpath)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "tursoPlugin"
    ];
  };

  passthru.tursoPluginDeps = fetchPnpmDeps {
    pname = "tauri-plugin-turso";
    version = finalAttrs.version;
    src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-quVUYsT3u4UBhuJ75QQ4SEuW8MhGQ0vGhtwtUj/eKHs=";
  };

  passthru.tursoPlugin = stdenv.mkDerivation {
    pname = "tauri-plugin-turso";
    version = finalAttrs.version;
    src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";

    nativeBuildInputs = [
      pnpm_11
      pnpmConfigHook
      nodejs
    ];

    pnpmDeps = finalAttrs.passthru.tursoPluginDeps;

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist-js "$out"
      runHook postInstall
    '';
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
