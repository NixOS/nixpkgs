{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  libxkbcommon,
  vulkan-loader,
  zstd,
  stdenv,
  darwin,
  wayland,
  gtk3,
  libGL,
  wget,
  tftp-hpa,
}:
rustPlatform.buildRustPackage rec {
  pname = "quick-serve";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "joaofl";
    repo = "quick-serve";
    rev = "v${version}";
    hash = "sha256-yO2D3w+aURLX8caFuadzRPdQDlI37ZB4CFzvO4J/zq8=";
  };

  cargoHash = "sha256-Cogt3eS97CM0Ym0k1C74NfIzNeC3ajIWdTsvwZtRL0U=";

  patches = [ ./remove-e2e-test-path.patch ];

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    copyDesktopItems
  ];

  nativeCheckInputs = [
    wget
    tftp-hpa
  ];

  buildInputs =
    [
      libxkbcommon
      vulkan-loader
      zstd
      gtk3
      libGL
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreGraphics
        Foundation
        Metal
        QuartzCore
        Security
      ]
    )
    ++ lib.optionals stdenv.isLinux [ wayland ];

  runtimeDependencies = [
    libxkbcommon
    libGL
  ] ++ lib.optionals stdenv.isLinux [ wayland ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postInstall = ''
    wrapProgram $out/bin/quick-serve \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Quick Serve";
      exec = "quick-serve";
      desktopName = "Quick Serve";
      comment = "Standalone server for a prompt file serving";
      categories = [
        "Network"
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Zero-config, multi-platform, multi-protocol standalone server for a prompt file serving";
    homepage = "https://github.com/joaofl/quick-serve";
    changelog = "https://github.com/joaofl/quick-serve/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "quick-serve";
  };
}
