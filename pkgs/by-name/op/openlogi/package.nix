{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-bundle,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  makeBinaryWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

let
  # crates/openlogi-desktop/build.rs embeds gpui-kit's themes, which live at
  # that repo's root rather than inside the crate, so cargo vendoring drops them.
  # Fetch the rev Cargo.lock pins and point build.rs's OPENLOGI_THEMES_DIR
  # escape hatch at it. This pin follows Cargo.lock rather than openlogi's
  # version, and nix-update does not maintain it.
  gpuiKitThemes = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "gpui-kit";
    rev = "1ac69bd51f744f3664361d9abd609bfc16de489f";
    hash = "sha256-up6s9rM5brgtiBQq9CSQRf8vJ4vE2ZhY4d8wRE1nfDk=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openlogi";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lJVX6pUFgv6bWDczIkLGkrx8iYIHuqu4a2Neu5rVVFI=";
  };

  cargoHash = "sha256-0fiv2CvzwjT1Wtia69RFm30Rdxl+CQV/0l4SnnoDBY4=";

  postPatch = ''
    grep -q 'gpui-kit?rev=${gpuiKitThemes.rev}' Cargo.lock || {
      echo "ERROR: gpui-kit revision needs update (must match Cargo.lock)"
      exit 1
    }

    # Dev-only cargo runner wraps test binaries in a throwaway .app bundle;
    # the Nix darwin sandbox refuses to exec it, so cargo test aborts with
    # EPERM before the binary runs. Strip it — tests don't need the bundle.
    substituteInPlace .cargo/config.toml \
      --replace-fail 'runner = ".cargo/run-macos.sh"' ""
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo-bundle
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
    openssl
    vulkan-loader
    wayland
  ];

  cargoBuildFlags = [
    "--package=openlogi"
    "--package=openlogi-desktop"
    "--package=openlogi-agent"
    "--package=openlogi-overlay"
  ];

  # xtask is upstream's release tooling; its tests shell out to git.
  cargoTestFlags = [
    "--workspace"
    "--exclude=xtask"
  ];

  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [
    "gpui_platform/runtime_shaders"
  ];

  env.OPENLOGI_THEMES_DIR = "${gpuiKitThemes}/themes";

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv "$release_target/openlogi-desktop" target/release/openlogi-desktop

    pushd crates/openlogi-desktop
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    popd

    mkdir -p "$out/Applications" "$out/bin"
    mv "$app_path" "$out/Applications/"

    install -Dm755 "$release_target/openlogi" "$out/bin/openlogi"

    # The GUI can only auto-start the agent and the Actions Ring overlay from
    # login-item helpers nested in its own bundle, resolved relative to its own
    # executable (the layout upstream's `xtask macos bundle` assembles for the
    # DMG). Info.plist and icon are upstream's own packaging inputs, installed
    # verbatim rather than re-authored here.
    installHelper() {
      local name="$1" binary="$2" plist="$3"
      local helper="$out/Applications/OpenLogi.app/Contents/Library/LoginItems/$name.app"

      install -Dm755 "$release_target/$binary" "$helper/Contents/MacOS/$binary"
      ln -s "$helper/Contents/MacOS/$binary" "$out/bin/$binary"

      install -Dm644 "crates/openlogi-desktop/bundle/$plist/Info.plist" \
        "$helper/Contents/Info.plist"

      # The plist ships a 0.0.0 version sentinel (xtask stamps it at bundle
      # time); stamp the package version instead.
      substituteInPlace "$helper/Contents/Info.plist" \
        --replace-fail "<string>0.0.0</string>" "<string>${finalAttrs.version}</string>"

      install -Dm644 crates/openlogi-desktop/icon/AppIcon.icns \
        "$helper/Contents/Resources/AppIcon.icns"
    }

    installHelper "OpenLogi Agent" openlogi-agent agent-release
    installHelper "OpenLogi Overlay" openlogi-overlay overlay-release
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 "$release_target/openlogi" "$out/bin/openlogi"
    install -Dm755 "$release_target/openlogi-desktop" "$out/bin/openlogi-desktop"
    install -Dm755 "$release_target/openlogi-agent" "$out/bin/openlogi-agent"
    install -Dm755 "$release_target/openlogi-overlay" "$out/bin/openlogi-overlay"

    # Upstream's own packaging inputs, installed verbatim rather than
    # re-authored here (they are what the .deb/.rpm ship).
    install -Dm644 packaging/linux/udev/70-openlogi.rules \
      "$out/lib/udev/rules.d/70-openlogi.rules"
    install -Dm644 packaging/linux/desktop/openlogi.desktop \
      "$out/share/applications/openlogi.desktop"
    install -Dm644 packaging/linux/systemd/openlogi-agent.service \
      "$out/share/systemd/user/openlogi-agent.service"

    # The unit hardcodes /usr/bin (upstream's install.sh rewrites it for a
    # custom PREFIX); point it at the store path instead.
    substituteInPlace "$out/share/systemd/user/openlogi-agent.service" \
      --replace-fail "ExecStart=/usr/bin/openlogi-agent" \
                     "ExecStart=$out/bin/openlogi-agent"

    for size in 16 32 48 64 128 256 512; do
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
            libxcb
            libxkbcommon
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
