{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # macOS
  cargo-bundle,
  apple-sdk,
  zip,

  # Linux
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  openssl,
  fontconfig,
  vulkan-loader,
  wayland,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "idle-hue";
  version = "0.9.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cyypherus";
    repo = "idle-hue";
    tag = finalAttrs.version;
    hash = "sha256-7VAK2vc9nCOu1ncYJnOgEMC2kOixmrKaAj635MHe7Zg=";
  };

  cargoHash = "sha256-9DVzfFlLlZIj8vACNKPRPC2E+V5mQXEm1h8DpWiOeiw=";

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      cargo-bundle
      # app-bundler calls zip to create archives before (skipped) upload
      zip
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
      copyDesktopItems
    ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      openssl
      fontconfig
    ];

  cargoBuildFlags = [
    "--package"
    "idle-hue"
  ]
  # app-bundler is needed on Darwin to produce the .app bundle
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--package"
    "app-bundler"
  ];

  # Skip the default cargoInstallHook on Darwin; on Linux the empty installPhase
  # lets cargoInstallHook run the standard cargo install.
  dontCargoInstall = stdenv.hostPlatform.isDarwin;

  # app-bundler calls dotenv().unwrap() which panics if no .env file is present.
  # In the Nix sandbox there is no .env, so we make failure non-fatal.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace app-bundler/src/main.rs \
      --replace-fail 'dotenv().unwrap();' 'let _ = dotenv();'
  '';

  # Also fails upstream
  checkFlags = [
    "--skip idle_hue_format_right_click_focus_rotates_after_each_field_has_been_focused"
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    vulkan-loader
    wayland
    libxkbcommon
    libGL
    libx11
    libxcursor
    libxi
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "idle-hue";
      desktopName = "idle-hue";
      type = "Application";
      comment = "Minimal, native color picker";
      exec = "idle-hue";
      icon = "idle-hue";
      terminal = false;
      categories = [
        "Graphics"
        "Utility"
      ];
    })
  ];

  # Already built
  env.CARGO_BUNDLE_SKIP_BUILD = lib.optionals stdenv.hostPlatform.isDarwin true;

  # Darwin uses app-bundler to produce a native .app bundle.
  # Linux relies on the default installation phase + copy hooks
  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"

    mv "$release_target/idle-hue" "target/release/idle-hue"

    "$release_target/app-bundler" \
      --skip-codesign \
      --skip-upload \
      --platforms ${if stdenv.hostPlatform.isx86_64 then "macos-intel" else "macos-arm"}

    mkdir -p "$out/"{Applications,bin}
    mv "target/release/bundle/osx/idle-hue.app" "$out/Applications/"
    ln -s "$out/Applications/idle-hue.app/Contents/MacOS/idle-hue" "$out/bin/"

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/share/icons/hicolor/32x32/apps"
    cp idle-hue/src/assets/icon32.png "$out/share/icons/hicolor/32x32/apps/idle-hue.png"
  '';

  meta = {
    description = "Minimal, native color picker";
    longDescription = ''
      A minimal, native color picker that lives in your menu bar.
      Built from scratch with love and Rust. Supports hex, rgb, and oklch
      color formats with an intuitive interface and palette management.
    '';
    homepage = "https://github.com/cyypherus/idle-hue";
    changelog = "https://github.com/cyypherus/idle-hue/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "idle-hue";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
