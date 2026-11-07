{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  cargo-bundle,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  re-plistbuddy,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

let
  # build.rs embeds gpui-kit's themes/, which cargo vendoring drops.
  # Must match Cargo.lock (checked in postPatch); nix-update does not bump it.
  gpuiComponentThemes = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "gpui-kit";
    rev = "1ac69bd51f744f3664361d9abd609bfc16de489f";
    hash = "sha256-up6s9rM5brgtiBQq9CSQRf8vJ4vE2ZhY4d8wRE1nfDk=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openlogi";
  version = "0.8.14";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d/G9BlF66mB7M9vpMVsSmuzA1i/4Zp9xYcWlUbfj3Z8=";
  };

  cargoHash = "sha256-PEPoV5QyjeUsFiGeZnKSvTsRCSAU1gClOTbnYCKz1V0=";

  postPatch = ''
    grep -q 'gpui-kit?rev=${gpuiComponentThemes.rev}' Cargo.lock || {
      echo "ERROR: gpui-component revision needs update (must match Cargo.lock)"
      exit 1
    }

    # Drop the dev-only macOS cargo runner; it re-bundles test binaries and fails in the sandbox.
    substituteInPlace .cargo/config.toml \
      --replace-fail 'runner = ".cargo/run-macos.sh"' ""
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo-bundle
    re-plistbuddy
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    freetype
    libGL
    libxcb
    libxkbcommon
    vulkan-loader
    wayland
  ];

  # Name the binaries, or the dev-only openlogi-agent-mock is built too.
  cargoBuildFlags = [
    "--package=openlogi"
    "--bin=openlogi"
    "--package=openlogi-desktop"
    "--bin=openlogi-desktop"
    "--package=openlogi-agent"
    "--bin=openlogi-agent"
    "--package=openlogi-overlay"
    "--bin=openlogi-overlay"
  ];

  cargoTestFlags = [
    "--workspace"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Upstream runs openlogi-desktop's tests on macOS only.
    "--exclude=openlogi-desktop"
  ];

  # Need a macOS desktop session (WindowServer, HIServices, powerd), absent in the sandbox.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=activity_macos::tests::the_spi_reports_a_running_cpu_and_accepts_a_subscription"
    "--skip=macos::tests::tap_callback_suppresses_normally_and_passes_through_panics"
    "--skip=macos::translate::tests::a_key_openlogi_posted_is_not_translated"
    "--skip=macos::tests::inverted_wheel_reaches_the_callback_reversed_and_the_desktop_reversed_once"
    "--skip=macos::tests::wheel_is_left_alone_when_inversion_is_off"
    "--skip=macos::tests::invert_scroll_event_keeps_every_magnitude"
    "--skip=inject::macos::keyboard_layout::tests::"
    "--skip=inject::macos::scroll::tests::smoothed_wheel_events_carry_no_phase"
    "--skip=inject::macos::scroll::tests::phased_gesture_events_carry_every_phase"
    # Hangs rather than fails.
    "--skip=inject::macos::tests::posted_key_edges_carry_the_synthetic_tag"
  ];

  # xtask's release tests `git init` throwaway repositories.
  nativeCheckInputs = [ git ];

  # Otherwise build.rs compiles the Metal shaders with Xcode's `xcrun metal`.
  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [
    "gpui_platform/runtime_shaders"
  ];

  env.OPENLOGI_THEMES_DIR = "${gpuiComponentThemes}/themes";

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv "$release_target/openlogi-desktop" target/release/openlogi-desktop

    pushd crates/openlogi-desktop
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release --format osx | xargs)
    popd

    mkdir -p "$out/Applications" "$out/bin"
    mv "$app_path" "$out/Applications/"
    app="$out/Applications/OpenLogi.app"

    # Mirrors upstream's `xtask macos bundle`, minus code signing, Assets.car and
    # the Sparkle updater.
    install -Dm755 "$release_target/openlogi" "$app/Contents/MacOS/openlogi"
    ln -s "$app/Contents/MacOS/openlogi" "$out/bin/openlogi"

    # The GUI finds its login-item helpers relative to its own executable.
    install_helper() {
      local name=$1 binary=$2 template=$3
      local helper="$app/Contents/Library/LoginItems/$name.app"
      install -Dm755 "$release_target/$binary" "$helper/Contents/MacOS/$binary"
      install -Dm644 "crates/openlogi-desktop/bundle/$template/Info.plist" \
        "$helper/Contents/Info.plist"
      substituteInPlace "$helper/Contents/Info.plist" \
        --replace-fail "<string>0.0.0</string>" "<string>${finalAttrs.version}</string>"
      install -Dm644 crates/openlogi-desktop/icon/AppIcon.icns \
        "$helper/Contents/Resources/AppIcon.icns"
    }
    install_helper "OpenLogi Agent" openlogi-agent agent-release
    install_helper "OpenLogi Overlay" openlogi-overlay overlay-release
    ln -s "$app/Contents/Library/LoginItems/OpenLogi Agent.app/Contents/MacOS/openlogi-agent" \
      "$out/bin/openlogi-agent"

    # Bundled launch agent, registered through SMAppService.
    install -Dm644 ${./org.openlogi.agent.service.plist} \
      "$app/Contents/Library/LaunchAgents/org.openlogi.agent.service.plist"

    # Keys upstream's `xtask macos package` stamps after cargo-bundle: the
    # minimum macOS version, the openlogi:// URL type, and the camera usage
    # description, without which macOS terminates the app on first access.
    # cargo-bundle writes the build time as CFBundleVersion; upstream stamps
    # the version, as in the helpers.
    PlistBuddy \
      -c "Merge ${./info-plist-keys.plist}" \
      -c "Set :CFBundleVersion ${finalAttrs.version}" \
      "$app/Contents/Info.plist"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 "$release_target/openlogi" "$out/bin/openlogi"
    install -Dm755 "$release_target/openlogi-desktop" "$out/bin/openlogi-desktop"
    install -Dm755 "$release_target/openlogi-agent" "$out/bin/openlogi-agent"
    install -Dm755 "$release_target/openlogi-overlay" "$out/bin/openlogi-overlay"

    install -Dm644 packaging/linux/udev/70-openlogi.rules \
      "$out/lib/udev/rules.d/70-openlogi.rules"
    install -Dm644 packaging/linux/desktop/openlogi.desktop \
      "$out/share/applications/openlogi.desktop"
    install -Dm644 packaging/linux/systemd/openlogi-agent.service \
      "$out/share/systemd/user/openlogi-agent.service"

    substituteInPlace "$out/share/systemd/user/openlogi-agent.service" \
      --replace-fail "ExecStart=/usr/bin/openlogi-agent" \
                     "ExecStart=$out/bin/openlogi-agent"

    install -Dm644 design/icon/openlogi.png \
      "$out/share/icons/hicolor/1024x1024/apps/openlogi.png"
    # A stock hicolor index stops at 512x512, so install the indexed sizes too.
    for size in 512 256 128 64 48 32 16; do
      install -Dm644 "design/icon/openlogi-$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/openlogi.png"
    done
  ''
  + ''
    runHook postInstall
  '';

  # GPUI (Blade) dlopen()s its Vulkan/Wayland/GL backends at runtime, so they
  # are invisible to the linker and must be on the wrapper's search path.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for program in openlogi-desktop openlogi-overlay; do
      wrapProgram "$out/bin/$program" \
        --suffix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libGL
            vulkan-loader
            wayland
          ]
        }"
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first companion for Logitech HID++ peripherals";
    homepage = "https://github.com/AprilNEA/OpenLogi";
    changelog = "https://github.com/AprilNEA/OpenLogi/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "openlogi";
    maintainers = with lib.maintainers; [ imcvampire ];
    platforms = lib.platforms.darwin ++ [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
