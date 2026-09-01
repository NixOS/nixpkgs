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
  # crates/openlogi-gui/build.rs embeds gpui-component's themes, which live at
  # that repo's root rather than inside the crate, so cargo vendoring drops them.
  # Fetch the rev Cargo.lock pins and point build.rs's OPENLOGI_THEMES_DIR
  # escape hatch at it. This pin follows Cargo.lock rather than openlogi's
  # version, and nix-update does not maintain it.
  gpuiComponentThemes = fetchFromGitHub {
    owner = "longbridge";
    repo = "gpui-component";
    rev = "031555662e99a1b5a549990b47f246d475b8288a";
    hash = "sha256-yOXdgxQgfvGN2/+OdDnl1pYti0DoGFvS3Tyqvj3Bkng=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openlogi";
  version = "0.6.25";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JziSstP3TdPVuqpZHtStT5fEy431tdFW7nB6bZvMyVA=";
  };

  cargoHash = "sha256-MVmPZ2IDss6+HmHKGdg4Q3g4W/fJgaQRGKoeUKDiEFU=";

  postPatch = ''
    grep -q 'gpui-component?rev=${gpuiComponentThemes.rev}' Cargo.lock || {
      echo "ERROR: gpui-component revision needs update (must match Cargo.lock)"
      exit 1
    }

    # gpui-component generates its IconName enum from a sibling assets directory,
    # but cargo vendoring stores gpui-component-assets as a separate package.
    for component in "$cargoDepsCopy"/source-git-*/gpui-component-[0-9]*; do
      component_parent=$(dirname "$component")
      ln -s "$component_parent"/gpui-component-assets-* "$component_parent/assets"
    done

    # Dev-only cargo runner wraps test binaries in a throwaway .app bundle;
    # the Nix darwin sandbox refuses to exec it, so cargo test aborts with
    # EPERM before the binary runs. Strip it — tests don't need the bundle.
    substituteInPlace .cargo/config.toml \
      --replace-fail 'runner = "scripts/cargo-run-macos.sh"' ""
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
    "--package=openlogi-gui"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--package=openlogi-agent"
  ];

  cargoTestFlags = [ "--workspace" ];

  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [
    "gpui_platform/runtime_shaders"
  ];

  env.OPENLOGI_THEMES_DIR = "${gpuiComponentThemes}/themes";

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv "$release_target/openlogi-gui" target/release/openlogi-gui

    pushd crates/openlogi-gui
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    popd

    mkdir -p "$out/Applications" "$out/bin"
    mv "$app_path" "$out/Applications/"
    install -Dm755 "$release_target/openlogi" "$out/bin/openlogi"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 "$release_target/openlogi" "$out/bin/openlogi"
    install -Dm755 "$release_target/openlogi-gui" "$out/bin/openlogi-gui"
    install -Dm755 "$release_target/openlogi-agent" "$out/bin/openlogi-agent"

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

    install -Dm644 design/icon/openlogi.png \
      "$out/share/icons/hicolor/1024x1024/apps/openlogi.png"
  ''
  + ''
    runHook postInstall
  '';

  # GPUI (Blade) dlopen()s its Vulkan/Wayland/GL backends at runtime, so they
  # are invisible to the linker and must be on the wrapper's search path.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/openlogi-gui" \
      --suffix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libxcb
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }"
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
